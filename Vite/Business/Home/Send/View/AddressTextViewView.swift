//
//  AddressTextViewView.swift
//  Vite
//
//  Created by Stone on 2018/10/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class AddressTextViewView: SendAddressViewType {

    fileprivate let addAddressButton = UIButton()
    fileprivate var floatView: AddAddressFloatView!

    let currentAddress: String?

    init(currentAddress: String? = nil) {
        self.currentAddress = currentAddress
        super.init(frame: CGRect.zero)

        titleLabel.text = R.string.localizable.sendPageToAddressTitle.key.localized()

        addSubview(titleLabel)
        addSubview(textView)
        addSubview(addAddressButton)

        if let _ = currentAddress {
            addAddressButton.setImage(R.image.icon_button_address_add(), for: .normal)
            addAddressButton.setImage(R.image.icon_button_address_add()?.highlighted, for: .highlighted)
            addAddressButton.rx.tap.bind { [weak self] in
                guard let `self` = self else { return }
                if let old = self.floatView {
                    old.removeFromSuperview()
                }
                self.floatView = AddAddressFloatView(targetView: self.addAddressButton, delegate: self)
                self.floatView.show()
            }.disposed(by: rx.disposeBag)
        } else {
            addAddressButton.setImage(R.image.icon_button_address_scan(), for: .normal)
            addAddressButton.setImage(R.image.icon_button_address_scan()?.highlighted, for: .highlighted)
            addAddressButton.rx.tap.bind { [weak self] in
                self?.scanButtonDidClick()
            }.disposed(by: rx.disposeBag)
        }

        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(self)
            m.left.equalTo(self).offset(24)
            m.right.equalTo(self).offset(-24)
        }

        textView.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom).offset(10)
            m.left.equalTo(titleLabel)
            m.right.equalTo(addAddressButton.snp.left).offset(-16)
            m.height.equalTo(55)
            m.bottom.equalTo(self)
        }

        addAddressButton.snp.makeConstraints { (m) in
            m.right.equalTo(titleLabel)
            m.bottom.equalTo(self).offset(-6)
        }

        textView.textColor = UIColor(netHex: 0x24272B)
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        let separatorLine = UIView()
        separatorLine.backgroundColor = Colors.lineGray
        addSubview(separatorLine)
        separatorLine.snp.makeConstraints { (m) in
            m.height.equalTo(CGFloat.singleLineWidth)
            m.left.right.equalTo(titleLabel)
            m.bottom.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AddressTextViewView: AddAddressFloatViewDelegate {

    func currentAddressButtonDidClick() {
        textView.text = currentAddress
    }

    func scanButtonDidClick() {
        let scanViewController = ScanViewController()
        scanViewController.reactor = ScanViewReactor()
        _ = scanViewController.rx.result.bind {[weak self] result in
            switch result {
            case .viteURI(let uri):
                if case .transfer(let address, _, _, _, _ ) = uri {
                    self?.textView.text = address.description
                }
            case .otherString:
                break
            }
        }
        self.ofViewController?.navigationController?.pushViewController(scanViewController, animated: true)
    }
}
