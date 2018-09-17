//
//  QRCodeViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx

class QRCodeViewController: BaseViewController {

    let account = HDWalletManager.instance.account()
    let bag = HDWalletManager.instance.bag()

    let titleLabel = UILabel().then {
        $0.backgroundColor = .red
    }

    let addressLabel = UILabel().then {
        $0.backgroundColor = .red
        $0.numberOfLines = 0
    }

    let qrcodeImageView = UIImageView().then {
        $0.backgroundColor = .red
    }

    let copyAddressButton = UIButton().then {
        $0.backgroundColor = .red
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createQRCode()
    }

    func setupUI() {
        title = LocalizationStr("My QRCode")
        titleLabel.text = account.name
        addressLabel.text = bag.address.description
        copyAddressButton.setTitle(LocalizationStr("Copy Address"), for: .normal)
        copyAddressButton.rx.tap.bind { [weak self] in
            guard let address = self?.bag.address.description else { return }
            UIPasteboard.general.string = address
            self?.copyAddressButton.setTitle(LocalizationStr("Copied"), for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.copyAddressButton.setTitle(LocalizationStr("Copy Address"), for: .normal)
            })
        }.disposed(by: rx.disposeBag)

        view.addSubview(titleLabel)
        view.addSubview(addressLabel)
        view.addSubview(qrcodeImageView)
        view.addSubview(copyAddressButton)

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.topMargin).offset(20)
            make.centerX.equalTo(view)
        }

        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }

        qrcodeImageView.snp.makeConstraints { (make) in
            make.top.equalTo(addressLabel.snp.bottom)
            make.centerX.equalTo(view)
            make.width.height.equalTo(200)
        }

        copyAddressButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-30)
            make.centerX.equalTo(view)
        }
    }

    func createQRCode() {
        DispatchQueue.global(qos: .userInteractive).async {
            let string = self.bag.address.description
            let context = CIContext()
            let data = string.data(using: String.Encoding.ascii)
            guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return }
            filter.setValue(data, forKey: "inputMessage")
            guard let output = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 7, y: 7)),
                let cgImage = context.createCGImage(output, from: output.extent) else {
                    return
            }
            DispatchQueue.main.async {
                self.qrcodeImageView.image  = UIImage.init(cgImage: cgImage)
            }
        }
    }
}
