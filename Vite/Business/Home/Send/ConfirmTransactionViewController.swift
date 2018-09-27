//
//  confirmViewController.swift
//  Vite
//
//  Created by haoshenyang on 2018/9/14.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class ConfirmTransactionViewController: UIViewController {

    let confirmView = ConfirmTransactionView()

    let completion: (Bool) -> Void

    init(confirmTypye: ConfirmTransactionView.ConfirmType,
         address: String,
         token: String,
         amount: String,
         completion:@escaping ((Bool) -> Void)) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        confirmView.tokenLabel.text = token
        confirmView.addressLabel.text = address
        confirmView.amountLabel.text = amount
        confirmView.type = confirmTypye
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    func setupUI() {
        view.backgroundColor = UIColor.init(netHex: 0x000000, alpha: 0.4)
        view.addSubview(confirmView)
        confirmView.snp.makeConstraints { (m) in
            m.leading.trailing.bottom.equalToSuperview()
            m.height.equalTo(334)
        }
    }

    func bind() {
        confirmView.closeButton.rx.tap
            .bind { [unowned self] in
                self.procese(false)
            }.disposed(by: rx.disposeBag)

        confirmView.confirmButton.rx.tap
            .bind { [weak self] in
                BiometryAuthenticationManager.shared.authenticate(reason: R.string.localizable.confirmTransactionPageBiometryConfirmReason(), completion: { (success, _) in
                    guard success else { return }
                    self?.procese(success)
                })
            }.disposed(by: rx.disposeBag)

        confirmView.enterPasswordButton.rx.tap
            .bind { [unowned self] in
                self.confirmView.type = .password
            }.disposed(by: rx.disposeBag)

        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow)
            .subscribe(onNext: {[weak self] (notification) in
                let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
                let height =  (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
                UIView.animate(withDuration: duration, animations: {
                    self?.confirmView.transform = CGAffineTransform(translationX: 0, y: -height)
                })
            }).disposed(by: rx.disposeBag)

        confirmView.passwordTextField.rx.text
            .bind { [weak self] password in
                if let password = password, password.count == 6 {
                    self?.procese(WalletDataService.shareInstance.verifyWalletPassword(pwd: password))
                }
            }.disposed(by: rx.disposeBag)
    }

    func procese(_ result: Bool) {
        if result {
            self.dismiss(animated: false, completion: {
                self.completion(result)
            })
        } else {
            Toast.show(R.string.localizable.confirmTransactionPageToastPasswordError())
        }
    }

}
