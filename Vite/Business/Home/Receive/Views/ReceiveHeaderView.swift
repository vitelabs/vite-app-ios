//
//  ReceiveHeaderView.swift
//  Vite
//
//  Created by Stone on 2018/9/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ReceiveHeaderView: UIView {

    fileprivate let logoView = UIImageView(image: R.image.login_logo())
    fileprivate let nameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = UIColor(netHex: 0x24272B)
        $0.textAlignment = .center
    }

    fileprivate lazy var addressBackView = UIView().then { view in
        view.backgroundColor = UIColor(netHex: 0xF3F5F9)
        view.addSubview(addressLabel)
        view.addSubview(copyButton)

        addressLabel.snp.makeConstraints { (m) in
            m.left.equalTo(view).offset(16)
            m.centerY.equalTo(view)
        }

        copyButton.snp.makeConstraints { (m) in
            m.top.bottom.right.equalTo(view)
            m.left.equalTo(addressLabel.snp.right)
            m.size.equalTo(CGSize(width: 56, height: 56))
        }
    }

    fileprivate let addressLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.numberOfLines = 2
    }

    fileprivate let copyButton = UIButton().then {
        $0.setImage(R.image.icon_button_paste_gray(), for: .normal)
        $0.setImage(R.image.icon_button_paste_gray()?.highlighted, for: .highlighted)

    }

    init(name: String, address: String) {
        super.init(frame: CGRect.zero)

        nameLabel.text = name
        addressLabel.text = address

        addSubview(logoView)
        addSubview(nameLabel)
        addSubview(addressBackView)

        logoView.snp.makeConstraints { (m) in
            m.top.equalTo(self).offset(18)
            m.centerX.equalTo(self)
            m.size.equalTo(CGSize(width: 48, height: 48))
        }

        nameLabel.snp.makeConstraints { (m) in
            m.top.equalTo(logoView.snp.bottom).offset(10)
            m.left.equalTo(self).offset(24)
            m.right.equalTo(self).offset(-24)
        }

        addressBackView.snp.makeConstraints { (m) in
            m.top.equalTo(nameLabel.snp.bottom).offset(15)
            m.left.equalTo(self).offset(24)
            m.right.equalTo(self).offset(-24)
            m.height.equalTo(56)
            m.bottom.equalTo(self)
        }

        copyButton.rx.tap
            .bind {
                UIPasteboard.general.string = address
                Toast.show(R.string.localizable.walletHomeToastCopyAddress(), duration: 1.0)
            }.disposed(by: rx.disposeBag)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
