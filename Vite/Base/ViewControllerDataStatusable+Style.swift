//
//  ViewControllerDataStatusable+Style.swift
//  Vite
//
//  Created by Stone on 2018/10/17.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

extension UIView {
    static func defaultPlaceholderView(text: String) -> UIView {
        let view = UIView()
        let layoutGuide = UILayoutGuide()
        let imageView = UIImageView(image: R.image.empty())
        let button = UIButton(type: .system).then {
            $0.isUserInteractionEnabled = false
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            $0.setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
            $0.setTitleColor(UIColor(netHex: 0x007AFF).highlighted, for: .highlighted)
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
}
