//
//  WalletHomeAddressView.swift
//  Vite
//
//  Created by Stone on 2018/9/15.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import Then

class WalletHomeAddressView: UIView {

    fileprivate let addressLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.numberOfLines = 2
    }

    fileprivate let copyButton = UIButton().then {
        $0.setImage(R.image.icon_button_paste_blue(), for: .normal)
        $0.setImage(R.image.icon_button_paste_blue()?.highlighted, for: .highlighted)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white

        let backView = UIView().then {
            $0.backgroundColor = UIColor(netHex: 0xF3F5F9)
        }

        addSubview(backView)
        backView.addSubview(addressLabel)
        backView.addSubview(copyButton)

        backView.snp.makeConstraints { (m) in
            m.top.equalTo(self)
            m.left.equalTo(self).offset(24)
            m.right.equalTo(self).offset(-24)
            m.height.equalTo(52)
            m.bottom.equalTo(self).offset(-20)
        }

        addressLabel.snp.makeConstraints { (m) in
            m.top.bottom.equalTo(backView)
            m.left.equalTo(backView).offset(16)
        }

        copyButton.snp.makeConstraints { (m) in
            m.top.bottom.right.equalTo(backView)
            m.size.equalTo(CGSize(width: 52, height: 52))
            m.left.equalTo(addressLabel.snp.right)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewModel: WalletHomeAddressViewModelType) {
        viewModel.defaultAddressDriver.drive(addressLabel.rx.text).disposed(by: rx.disposeBag)
        copyButton.rx.tap.bind { viewModel.copy() }.disposed(by: rx.disposeBag)
    }
}
