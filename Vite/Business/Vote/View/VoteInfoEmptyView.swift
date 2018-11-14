//
//  VoteInfoEmptyView.swift
//  Vite
//
//  Created by Water on 2018/11/8.
//  Copyright © 2018 vite labs. All rights reserved.
//

class VoteInfoBgView: UIView {
    lazy var bgImg: UIImageView = {
        let bgImg = UIImageView()
        bgImg.isUserInteractionEnabled = true
        bgImg.image = R.image.vote_info_bg()
        return bgImg
    }()

    lazy var dotImg: UIImageView = {
        let dotImg = UIImageView()
        dotImg.isUserInteractionEnabled = true
        dotImg.image = R.image.vote_info_dot()
        return dotImg
    }()

    lazy var lineImg: UIImageView = {
        let lineImg = UIImageView()
        lineImg.isUserInteractionEnabled = true
        lineImg.image = R.image.dotted_line()?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .tile)
        return lineImg
    }()

    lazy var iconImg: UIImageView = {
        let iconImg = UIImageView()
        iconImg.isUserInteractionEnabled = true
        iconImg.image = R.image.vote_info_icon()
        return iconImg
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true

        self.addSubview(bgImg)
        bgImg.snp.makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalTo(self)
        }

        self.addSubview(iconImg)
        iconImg.snp.makeConstraints { (make) -> Void in
            make.bottom.right.equalTo(self)
        }
        self.addSubview(lineImg)
        lineImg.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(46)
            make.height.equalTo(1)
        }

        self.addSubview(dotImg)
        dotImg.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(5)
            make.top.equalTo(self).offset(41)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VoteInfoEmptyView: UIView {
    lazy var descLab: UILabel = {
        let descLab = UILabel()
        descLab.textAlignment = .left
        descLab.font = Fonts.Font20
        descLab.textColor  = .white
        descLab.alpha  = 0.7
        descLab.text =  R.string.localizable.votePageInfoNodataTitle.key.localized()
        return descLab
    }()

    lazy var bgView: VoteInfoBgView = {
        let bgView = VoteInfoBgView()
        bgView.lineImg.isHidden = true
        return bgView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self._addViewConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func _addViewConstraint() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }

        self.addSubview(descLab)
        descLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(60)
            make.left.equalTo(self).offset(30)
            make.height.equalTo(28)
        }
    }
}
