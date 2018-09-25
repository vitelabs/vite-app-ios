//
//  FetchWelfareCardView.swift
//  Vite
//
//  Created by Water on 2018/9/21.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import Then

class FetchWelfareCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let bgImgView = UIImageView().then {
            $0.backgroundColor = .clear
            $0.image = R.image.fetch_gift_bg()
            $0.layer.cornerRadius = 2
            $0.layer.masksToBounds = true
        }
        self.addSubview(bgImgView)

        let iconImgView = UIImageView().then {
            $0.backgroundColor = .clear
            $0.image = R.image.fetch_gift_icon()
        }
        self.addSubview(iconImgView)

        let titleLab = UILabel().then {
            $0.backgroundColor = .clear
            $0.textAlignment = .center
            $0.font = Fonts.Font16
            $0.textColor = .white
            $0.text = R.string.localizable.fetchWelfareContentTitle.key.localized()
        }
        self.addSubview(titleLab)

        let descLab = UILabel().then {
            $0.backgroundColor = .clear
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.font = Fonts.Font14
            $0.textColor = .white
        }
        self.addSubview(descLab)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 10
        let attributes = [NSAttributedStringKey.font: Fonts.Font14,
                                  NSAttributedStringKey.foregroundColor: UIColor.white,
                          NSAttributedStringKey.paragraphStyle: paragraph]
        descLab.attributedText = NSAttributedString(string: R.string.localizable.fetchWelfareContentDesc.key.localized(), attributes: attributes)

        bgImgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        iconImgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-2)
            make.right.equalTo(self).offset(-24)
        }

        titleLab.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(48)
        }

        let lineView = LineView.init(direction: .horizontal)
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(titleLab)
            make.height.equalTo(1)
        }

        descLab.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(38)
            make.right.equalTo(self).offset(-38)
            make.top.equalTo(titleLab.snp.bottom).offset(20)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
