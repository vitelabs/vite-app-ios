//
//  SearchBar.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/8.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class SearchBar: UIImageView {

    var placeholder: String? {
        didSet {
            self.textField.placeholder = placeholder
        }
    }

    let leftIcon = UIImageView().then {
        $0.image = R.image.icon_search()
    }

    let textField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 13)
    }

     init() {
        super.init(frame: .zero)

        self.isUserInteractionEnabled = true
        self.image = R.image.icon_background()?.resizable

        self.addSubview(leftIcon)
        self.addSubview(textField)
        textField.delegate = self

        leftIcon.snp.makeConstraints { (m) in
            m.width.height.equalTo(12)
            m.left.equalToSuperview().offset(20)
            m.top.equalToSuperview().offset(19)
        }

        textField.snp.makeConstraints { (m) in
            m.centerY.equalTo(leftIcon)
            m.left.equalTo(leftIcon.snp.right).offset(10)
            m.right.equalToSuperview().offset(-10)
            m.height.equalTo(36)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchBar: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.leftIcon.image = R.image.icon_search()

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.leftIcon.image = R.image.icon_search()
    }
}

extension Reactive where Base: SearchBar {

    var text: ControlProperty<String?> {
        return base.textField.rx.text
    }
}
