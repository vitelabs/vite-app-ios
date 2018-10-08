//
//  AddressManageGenerateAddressCell.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class AddressManageGenerateAddressCell: BaseTableViewCell {

    let generateButton = UIButton(type: .system).then {
        $0.isUserInteractionEnabled = false
        $0.setTitle("    +    ", for: .normal)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(generateButton)
        generateButton.snp.makeConstraints { (m) in
            m.top.bottom.left.right.equalTo(contentView)
            m.height.equalTo(40)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
