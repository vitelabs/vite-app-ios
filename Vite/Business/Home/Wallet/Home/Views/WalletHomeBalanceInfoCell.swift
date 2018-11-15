//
//  WalletHomeBalanceInfoCell.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import ChameleonFramework

class WalletHomeBalanceInfoCell: BaseTableViewCell {

    static var cellHeight: CGFloat {
        return 130
    }

    fileprivate let colorView = UIImageView()
    fileprivate let iconImageView = UIImageView()

    fileprivate let symbolLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = UIColor.white
    }

    fileprivate let balanceLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = UIColor(netHex: 0x24272B)
        $0.numberOfLines = 1
    }

    fileprivate let unconfirmedLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(netHex: 0x4B5461)
        $0.numberOfLines = 1
    }

    fileprivate let highlightedMaskView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 2
        $0.isUserInteractionEnabled = false
        $0.isHidden = true
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let whiteView = UIView().then {
            $0.backgroundColor = UIColor.white
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 2
        }

        let arrowView = UIImageView(image: R.image.icon_right_white())
        let balanceTitleView = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textColor = UIColor(netHex: 0x3E4A59)
            $0.text = R.string.localizable.walletHomeBalanceTitle()
        }

        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        let shadowView = UIView.embedInShadowView(customView: whiteView, width: 0, height: 5, radius: 20)
        contentView.addSubview(shadowView)
        contentView.addSubview(highlightedMaskView)

        colorView.addSubview(iconImageView)
        colorView.addSubview(symbolLabel)
        colorView.addSubview(arrowView)

        whiteView.addSubview(colorView)
        whiteView.addSubview(balanceTitleView)
        whiteView.addSubview(balanceLabel)
        whiteView.addSubview(unconfirmedLabel)

        shadowView.snp.makeConstraints { (m) in
            m.top.equalTo(contentView)
            m.left.equalTo(contentView).offset(24)
            m.right.equalTo(contentView).offset(-24)
            m.height.equalTo(110)
            m.bottom.equalTo(contentView).offset(-20)
        }

        highlightedMaskView.snp.makeConstraints { (m) in
            m.edges.equalTo(shadowView)
        }

        colorView.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(whiteView)
            m.height.equalTo(56)
        }

        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        iconImageView.snp.makeConstraints { (m) in
            m.centerY.equalTo(colorView)
            m.left.equalTo(colorView).offset(16)
            m.size.equalTo(CGSize(width: 32, height: 32))
        }

        symbolLabel.snp.makeConstraints { (m) in
            m.centerY.equalTo(colorView)
            m.left.equalTo(iconImageView.snp.right).offset(10)
        }

        arrowView.setContentHuggingPriority(.required - 1, for: .horizontal)
        arrowView.setContentCompressionResistancePriority(.required - 1, for: .horizontal)
        arrowView.snp.makeConstraints { (m) in
            m.centerY.equalTo(colorView)
            m.left.equalTo(symbolLabel.snp.right).offset(10)
            m.right.equalTo(colorView).offset(-10)
        }

        balanceTitleView.snp.makeConstraints { (m) in
            m.top.equalTo(colorView.snp.bottom).offset(17)
            m.left.equalTo(whiteView).offset(16)
        }

        balanceLabel.snp.makeConstraints { (m) in
            m.top.equalTo(colorView.snp.bottom).offset(8)
            m.right.equalTo(whiteView).offset(-16)
        }

        unconfirmedLabel.snp.makeConstraints { (m) in
            m.right.equalTo(whiteView).offset(-16)
            m.bottom.equalTo(whiteView).offset(-8)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        highlightedMaskView.isHidden = !highlighted
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        highlightedMaskView.isHidden = !selected
    }

    func bind(viewModel: WalletHomeBalanceInfoViewModelType) {

        viewModel.token.icon.putIn(iconImageView)
        symbolLabel.text = viewModel.symbol
        balanceLabel.text = viewModel.balance.amountShort(decimals: viewModel.token.decimals)
        unconfirmedLabel.text = R.string.localizable.walletHomeUnconfirmedTitle(viewModel.unconfirmed.amountShort(decimals: viewModel.token.decimals))
        DispatchQueue.main.async {
            self.colorView.backgroundColor = GradientColor(.leftToRight, frame: self.colorView.frame, colors: viewModel.token.backgroundColors)
        }
    }
}
