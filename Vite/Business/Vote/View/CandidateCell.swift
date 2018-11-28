//
//  CandidateCell.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/8.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift

class CandidateCell: UITableViewCell {

    var disposeable: Disposable?

    let nodeNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.init(netHex: 0x3E4A59)
        $0.adjustsFontSizeToFitWidth = true
    }

    let voteRankImageView = UIImageView(image: R.image.icon_vote_rank())

    let voteRankLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x3093FF)
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }

    let voteCountIcon = UIImageView().then {
        $0.image = R.image.icon_votecount()
    }

    let voteDescriptionLabel = UILabel().then {
        $0.text = R.string.localizable.voteListCount()
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.init(netHex: 0x3E4A59, alpha: 0.6)
    }

    let voteCountLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.init(netHex: 0x3E4A59)
    }

    let addressIcon = UIImageView().then {
        $0.image = R.image.icon_voteaddress()
    }

    let addressDescriptionLabel = UILabel().then {
        $0.text = R.string.localizable.voteListAddress()
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.init(netHex: 0x3E4A59, alpha: 0.6)
    }

    let addressLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor.init(netHex: 0x3E4A59)
        $0.backgroundColor = UIColor.init(netHex: 0xF3F5F9)
        $0.lineBreakMode = .byTruncatingMiddle
    }

    let voteButton = UIButton().then {
        $0.setTitle(R.string.localizable.vote(), for: .normal)
        $0.backgroundColor = UIColor.init(netHex: 0x007AFF)
        $0.layer.cornerRadius = 11
        $0.layer.masksToBounds = true
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.separatorInset = UIEdgeInsets.init(top: 0, left: 24, bottom: 0, right: 24)
        self.selectionStyle = .none

        for view in [voteRankImageView, voteRankLabel, nodeNameLabel, voteCountIcon, voteDescriptionLabel, voteCountLabel, addressIcon, addressDescriptionLabel, addressLabel, voteButton] {
            contentView.addSubview(view)
        }

        voteRankImageView.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(14)
            m.right.equalToSuperview().offset(-24)
            m.width.equalTo(20)
        }

        voteRankLabel.snp.makeConstraints { (m) in
            m.centerX.equalTo(voteRankImageView)
            m.top.equalTo(voteRankImageView).offset(4)
        }

        nodeNameLabel.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(14)
            m.left.equalToSuperview().offset(24)
            m.right.equalTo(voteRankImageView.snp.left).offset(-6)
        }

        voteCountIcon.snp.makeConstraints { (m) in
            m.left.equalToSuperview().offset(24)
            m.width.height.equalTo(14)
            m.top.equalTo(nodeNameLabel.snp.bottom).offset(11)
        }

        voteDescriptionLabel.snp.makeConstraints { (m) in
            m.left.equalTo(voteCountIcon.snp.right).offset(7)
            m.centerY.equalTo(voteCountIcon)
        }

        voteCountLabel.snp.makeConstraints { (m) in
            m.left.equalTo(voteDescriptionLabel.snp.right).offset(10)
            m.centerY.equalTo(voteCountIcon)
            m.right.lessThanOrEqualTo(voteButton.snp.right)
        }

        addressIcon.snp.makeConstraints { (m) in
            m.left.equalToSuperview().offset(24)
            m.width.height.equalTo(14)
            m.top.equalTo(voteCountIcon.snp.bottom).offset(16)
        }

        addressDescriptionLabel.snp.makeConstraints { (m) in
            m.left.equalTo(addressIcon.snp.right).offset(7)
            m.centerY.equalTo(addressIcon)
        }

        addressLabel.snp.makeConstraints { (m) in
            m.left.equalTo(addressDescriptionLabel.snp.right).offset(16)
            m.centerY.equalTo(addressIcon)
            m.right.equalTo(voteButton.snp.left).offset(-16)
        }

        voteButton.snp.makeConstraints { (m) in
            m.right.equalToSuperview().offset(-24)
            m.centerY.equalTo(addressIcon)
            m.width.equalTo(50)
            m.height.equalTo(25)
        }
    }

    func updateRank(_ rank: Int) {
        voteRankLabel.text = String(rank)
        if rank < 10 {
            voteRankImageView.snp.updateConstraints { (m) in m.width.equalTo(20) }
        } else if rank < 100 {
            voteRankImageView.snp.updateConstraints { (m) in m.width.equalTo(25) }
        } else {
            voteRankImageView.snp.updateConstraints { (m) in m.width.equalTo(30) }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
