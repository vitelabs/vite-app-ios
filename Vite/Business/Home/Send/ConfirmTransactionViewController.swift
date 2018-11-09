//
//  confirmViewController.swift
//  Vite
//
//  Created by haoshenyang on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

extension ConfirmViewController {

    //Send Transcation Normally
    convenience init(confirmType: ConfirmTransactionType,
                     address: String,
                     token: String,
                     amount: String,
                     completion:@escaping ((ConfirmTransactionResult) -> Void)) {
        self.init(confirmType: confirmType,
                  title: R.string.localizable.confirmTransactionPageTitle.key.localized(),
                  infoTitle: R.string.localizable.confirmTransactionAddressTitle.key.localized(),
                  info: address,
                  token: token,
                  amount: amount,
                  confirmTitle: R.string.localizable.confirmTransactionPageConfirmButton.key.localized(),
                  completion: completion)
    }

    //Comfirm Vote
    class func comfirmVote(title: String,
                           nodeName: String,
                           completion:@escaping ((ConfirmTransactionResult) -> Void)) -> ConfirmTransactionViewController {

        let biometryAuthConfig = HDWalletManager.instance.isTransferByBiometry
        let confirmType: ConfirmTransactionViewController.ConfirmTransactionType =  biometryAuthConfig ? .biometry : .password
        return ConfirmTransactionViewController
            .init(confirmType: confirmType,
                  title: title,
                  infoTitle: R.string.localizable.confirmTransactionPageNodeName.key.localized(),
                  info: nodeName,
                  token: nil,
                  amount: nil,
                  confirmTitle: R.string.localizable.voteListConfirmButtonTitle.key.localized(),
                  completion: completion)
    }

}

typealias ConfirmTransactionViewController = ConfirmViewController

class ConfirmViewController: UIViewController, PasswordInputViewDelegate {

    enum ConfirmTransactionType {
        case password
        case biometry
    }

    enum ConfirmTransactionResult {
        case cancelled
        case success
        case biometryAuthFailed
        case passwordAuthFailed
    }

    init(confirmType: ConfirmTransactionType,
         title: String,
         infoTitle: String,
         info: String,
         token: String?,
         amount: String?,
         confirmTitle: String,
         completion:@escaping ((ConfirmTransactionResult) -> Void)) {

        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom

        confirmView.type = confirmType
        confirmView.titleLabel.text = title
        confirmView.infoTitleLabel.text = infoTitle
        confirmView.infoLabel.text = info
        confirmView.amountLabel.text = amount
        confirmView.tokenLabel.text = token
        confirmView.confirmButton.setTitle(confirmTitle, for: .normal)

        if token == nil && amount == nil {
            confirmViewHeight = 224
            confirmView.transactionInfoView.backgroundView.isHidden = true
            confirmView.transactionInfoView.tokenLabel.isHidden = true
            confirmView.transactionInfoView.amountLabel.isHidden = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let confirmView = ConfirmTransactionView()
    let completion: (ConfirmTransactionResult) -> Void
    var confirmViewHeight = 334.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    func setupUI() {
        view.backgroundColor = UIColor.init(netHex: 0x000000, alpha: 0.4)
        view.addSubview(confirmView)
        confirmView.passwordView.delegate = self
        confirmView.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalTo(confirmViewHeight)
        }
    }

    func bind() {
        confirmView.closeButton.rx.tap
            .bind { [unowned self] in
                self.procese(.cancelled)
            }.disposed(by: rx.disposeBag)

        confirmView.confirmButton.rx.tap
            .bind { [weak self] in
                BiometryAuthenticationManager.shared.authenticate(reason: R.string.localizable.confirmTransactionPageBiometryConfirmReason.key.localized(), completion: { (success, error) in
                    if let error =  error as NSError? {
                        switch error.code {
                        case -8: Toast.show(error.localizedDescription)
                        default: break
                        }
                    } else if success {
                        self?.procese(.success)
                    }
                })
            }.disposed(by: rx.disposeBag)

        confirmView.enterPasswordButton.rx.tap
            .bind { [unowned self] in
                self.confirmView.type = .password
            }.disposed(by: rx.disposeBag)

        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow)
            .filter { [weak self] _  in
                return self?.confirmView.type == .password && self?.confirmView.transform == .identity
            }
            .subscribe(onNext: {[weak self] (notification) in
                let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
                let height =  (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
                UIView.animate(withDuration: duration, animations: {
                    self?.confirmView.transform = CGAffineTransform(translationX: 0, y: -height)
                })
            }).disposed(by: rx.disposeBag)
    }

    func inputFinish(passwordView: PasswordInputView, password: String) {
        let result = HDWalletManager.instance.verifyPassword(password)
        self.procese(result ? .success : .passwordAuthFailed)
    }

    func procese(_ result: ConfirmTransactionResult) {
        self.dismiss(animated: false, completion: {
            self.completion(result)
        })
    }

}
