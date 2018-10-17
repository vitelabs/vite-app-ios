//
//  MnemonicTextView.swift
//  Vite
//
//  Created by Water on 2018/10/17.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class MnemonicTextView: UIView {

    lazy var contentTextView: UITextView = {
        let contentTextView =  UITextView()
        contentTextView.backgroundColor = .clear
        contentTextView.font = Fonts.Font18
        contentTextView.textColor = Colors.descGray
        contentTextView.text = ""
        contentTextView.isEditable = true
        contentTextView.isScrollEnabled = true
        return contentTextView
    }()

    init(isEditable: Bool) {
        super.init(frame: CGRect.zero)

        self.backgroundColor = Colors.bgGray
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 2

        addSubview(contentTextView)
        contentTextView.isEditable = isEditable

        contentTextView.snp.makeConstraints { (m) in
            m.top.left.equalTo(self).offset(10)
            m.bottom.right.equalTo(self).offset(-10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var text: String {
        return contentTextView.text
    }
}
