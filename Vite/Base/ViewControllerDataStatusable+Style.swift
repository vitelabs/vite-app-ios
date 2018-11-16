//
//  ViewControllerDataStatusable+Style.swift
//  Vite
//
//  Created by Stone on 2018/10/17.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import RxSwift

extension UIView {
    static func defaultPlaceholderView(text: String) -> UIView {
        let view = UIView()
        let layoutGuide = UILayoutGuide()
        let imageView = UIImageView(image: R.image.empty())
        let button = UIButton(type: .system).then {
            $0.isUserInteractionEnabled = false
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            $0.setTitleColor(UIColor(netHex: 0x3E4A59, alpha: 0.45), for: .normal)
            $0.setTitleColor(UIColor(netHex: 0x3E4A59, alpha: 0.45).highlighted, for: .highlighted)
            $0.setTitle(text, for: .normal)
        }

        view.addLayoutGuide(layoutGuide)
        view.addSubview(imageView)
        view.addSubview(button)

        layoutGuide.snp.makeConstraints { (m) in
            m.center.equalTo(view)
        }

        imageView.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(layoutGuide)
        }

        button.snp.makeConstraints { (m) in
            m.top.equalTo(imageView.snp.bottom).offset(20)
            m.left.right.bottom.equalTo(layoutGuide)
        }

        return view
    }

    static func  defaultNetworkErrorView(error: Error, retry: @escaping () -> Void) -> UIView {

        let view = UIView()
        let layoutGuide = UILayoutGuide()
        let imageView = UIImageView(image: R.image.network_error())
        let label = UILabel().then {
            $0.textColor = UIColor(netHex: 0x3E4A59).withAlphaComponent(0.45)
            $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            $0.text = error.message
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }

        let button = UIButton(type: .system).then {
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            $0.setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
            $0.setTitleColor(UIColor(netHex: 0x007AFF).highlighted, for: .highlighted)
            $0.setTitle(R.string.localizable.transactionListPageNetworkError(), for: .normal)
        }

        view.addLayoutGuide(layoutGuide)
        view.addSubview(imageView)
        view.addSubview(label)
        view.addSubview(button)

        layoutGuide.snp.makeConstraints { (m) in
            m.centerY.equalTo(view)
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
        }

        imageView.snp.makeConstraints { (m) in
            m.top.centerX.equalTo(layoutGuide)
        }

        label.snp.makeConstraints { (m) in
            m.top.equalTo(imageView.snp.bottom).offset(20)
            m.left.right.equalTo(layoutGuide)
        }

        button.snp.makeConstraints { (m) in
            m.top.equalTo(label.snp.bottom).offset(20)
            m.left.right.bottom.equalTo(layoutGuide)
        }

        button.rx.tap.bind {
            retry()
        }.disposed(by: view.rx.disposeBag)

        return view
    }
}
