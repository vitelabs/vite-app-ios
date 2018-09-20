//
//  ReceiveViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import ChameleonFramework

class ReceiveViewController: BaseViewController {

    let bag = HDWalletManager.instance.bag()
    let token: Token

    init(token: Token) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let tokenNameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = UIColor(netHex: 0x24272B)
        $0.numberOfLines = 0
    }

    let qrcodeImageView = UIImageView()

    func setupView() {

        navigationBarStyle = .clear
        navigationItem.title = R.string.localizable.receivePageTitle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.icon_nav_share_black(), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(onShare))
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: token.backgroundColors)

        let whiteView = UIImageView(image: R.image.background_button_white()?.resizable).then {
            $0.isUserInteractionEnabled = true
            $0.layer.shadowColor = UIColor(netHex: 0x000000).cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowRadius = 20
        }

        kas_activateAutoScrollingForView(whiteView)

        view.addSubview(whiteView)

        let logoView = UIImageView(image: R.image.login_logo())
        let nameLabel = UILabel().then {
            $0.font = UIFont.boldSystemFont(ofSize: 16)
            $0.textColor = UIColor(netHex: 0x24272B)
            $0.text = HDWalletManager.instance.account().name
        }

        let addressBackView = UIView().then {
            $0.backgroundColor = UIColor(netHex: 0xF3F5F9)
        }

        let addressLabel = UILabel().then {
            $0.font = UIFont.boldSystemFont(ofSize: 12)
            $0.textColor = UIColor(netHex: 0x3E4A59)
            $0.numberOfLines = 2
            $0.text = HDWalletManager.instance.bag().address.description
        }

        let copyButton = UIButton().then {
            $0.setImage(R.image.icon_button_paste_blue(), for: .normal)
            $0.setImage(R.image.icon_button_paste_blue()?.highlighted, for: .highlighted)
            $0.rx.tap
                .bind {
                    UIPasteboard.general.string = HDWalletManager.instance.bag().address.description
                    Toast.show(R.string.localizable.walletHomeToastCopyAddress(), duration: 1.0)
                }.disposed(by: rx.disposeBag)
        }

        let amountButton = UIButton().then {
            $0.setTitle(R.string.localizable.receivePageTokenAmountButtonTitle(), for: .normal)
            $0.setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
            $0.setTitleColor(UIColor(netHex: 0x007AFF).highlighted, for: .highlighted)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            $0.rx.tap
                .bind {

                }.disposed(by: rx.disposeBag)
        }

        let noteTitleTextFieldView = TitleTextFieldView(title: R.string.localizable.receivePageTokenNoteLabel())

        whiteView.addSubview(logoView)
        whiteView.addSubview(nameLabel)
        whiteView.addSubview(addressBackView)
        whiteView.addSubview(tokenNameLabel)
        whiteView.addSubview(qrcodeImageView)
        whiteView.addSubview(amountButton)
        whiteView.addSubview(noteTitleTextFieldView)

        addressBackView.addSubview(addressLabel)
        addressBackView.addSubview(copyButton)

        whiteView.snp.makeConstraints { (m) in
            m.top.equalTo(view.safeAreaLayoutGuideSnpTop).offset(6)
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
        }

        logoView.snp.makeConstraints { (m) in
            m.top.equalTo(whiteView).offset(18)
            m.centerX.equalTo(whiteView)
            m.size.equalTo(CGSize(width: 48, height: 48))
        }

        nameLabel.snp.makeConstraints { (m) in
            m.top.equalTo(logoView.snp.bottom).offset(10)
            m.centerX.equalTo(whiteView)
        }

        addressBackView.snp.makeConstraints { (m) in
            m.top.equalTo(nameLabel.snp.bottom).offset(15)
            m.left.equalTo(whiteView).offset(24)
            m.right.equalTo(whiteView).offset(-24)
            m.height.equalTo(56)
        }

        addressLabel.snp.makeConstraints { (m) in
            m.left.equalTo(addressBackView).offset(16)
            m.centerY.equalTo(addressBackView)
        }

        copyButton.snp.makeConstraints { (m) in
            m.top.bottom.right.equalTo(addressBackView)
            m.left.equalTo(addressLabel.snp.right)
            m.size.equalTo(CGSize(width: 56, height: 56))
        }

        tokenNameLabel.snp.makeConstraints { (m) in
            m.top.equalTo(addressBackView.snp.bottom).offset(20)
            m.left.right.equalTo(addressBackView)
        }

        qrcodeImageView.snp.makeConstraints { (m) in
            m.top.equalTo(tokenNameLabel.snp.bottom).offset(20)
            m.centerX.equalTo(whiteView)
            m.size.equalTo(CGSize(width: 170, height: 170))
        }

        amountButton.snp.makeConstraints { (m) in
            m.top.equalTo(qrcodeImageView.snp.bottom).offset(20)
            m.centerX.equalTo(whiteView)
        }

        noteTitleTextFieldView.snp.makeConstraints { (m) in
            m.top.equalTo(amountButton.snp.bottom).offset(20)
            m.left.equalTo(whiteView).offset(24)
            m.right.equalTo(whiteView).offset(-24)
            m.bottom.equalTo(whiteView).offset(-30)
        }

        noteTitleTextFieldView.textField.kas_setReturnAction(.done(block: {
            $0.resignFirstResponder()
        }))

        tokenNameLabel.text = "sdaflksdaseaufewaiewafweauwaufesaumseaiaskfewaf"
        qrcodeImageView.backgroundColor = UIColor.red


    }

    @objc func onShare() {

    }
}
