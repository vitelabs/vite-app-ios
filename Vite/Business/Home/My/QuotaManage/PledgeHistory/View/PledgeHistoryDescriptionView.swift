//
//  PledgeHistoryDescriptionView.swift
//  Vite
//
//  Created by haoshenyang on 2018/10/29.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

final class PledgeHistoryDescriptionView: UIImageView {

    init() {
        super.init(frame: .zero)

        self.image = R.image.icon_background()!.resizable

        let beelBackgroundView = UIView()
        beelBackgroundView.backgroundColor = UIColor.init(netHex: 0xB5C8F8, alpha: 0.23)
        self.addSubview(beelBackgroundView)
        beelBackgroundView.snp.makeConstraints { (m) in
            m.left.equalTo(self).offset(10)
            m.top.equalTo(self).offset(6.5)
            m.bottom.equalTo(self).offset(-10)
            m.width.equalTo(62)
        }

        let beelView = UIImageView()
        beelView.image = R.image.quota_bell()!
        self.addSubview(beelView)
        beelView.snp.makeConstraints { (m) in
            m.centerY.equalTo(beelBackgroundView)
            m.centerX.equalTo(beelBackgroundView)
            m.width.height.equalTo(30)
        }

        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.init(netHex: 0x5D6D82)
        label.font = UIFont.systemFont(ofSize: 11)
        label.text = R.string.localizable.peldgeMessage()
        self.addSubview(label)
        label.snp.makeConstraints { (m) in
            m.centerY.equalTo(self)
            m.right.equalTo(self).offset(-24)
            m.left.equalTo(beelBackgroundView.snp.right).offset(12)
            m.top.equalTo(self.snp.top)
            m.bottom.equalTo(self.snp.bottom)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
