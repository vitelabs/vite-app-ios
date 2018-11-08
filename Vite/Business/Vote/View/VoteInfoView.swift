//
//  ViewInfoView.swift
//  Vite
//
//  Created by Water on 2018/11/6.
//  Copyright © 2018年 vite labs. All rights reserved.
//

enum VoteStatus: Int {
    case voteSuccess = 1
    case voting = 2
    case cancelVoting = 3
    case cancelVoteSuccess = 4
    case voteInvalid = 5

    var display: String {
        switch self {
        case .voteSuccess:
            return "投票成功"
        case .voting:
            return "正在投票中"
        case .cancelVoting:
            return "正在撤销中"
        case .cancelVoteSuccess:
            return ""
        case .voteInvalid:
            return "投票作废"
        }
    }
}
class VoteInfoView: UIView {
    lazy var bgView: VoteInfoBgView = {
        let bgView = VoteInfoBgView()
        bgView.iconImg.isHidden = true
        return bgView
    }()

    lazy var nodeNameLab: UILabel = {
        let nodeNameLab = UILabel()
        nodeNameLab.textAlignment = .left
        nodeNameLab.font = Fonts.Font16_b
        nodeNameLab.textColor  = .white
        return nodeNameLab
    }()

    lazy var nodeStatusLab: UILabel = {
        let nodeStatusLab = UILabel()
        nodeStatusLab.textAlignment = .left
        nodeStatusLab.font = Fonts.Font14_b
        nodeStatusLab.textColor  = .white
        return nodeStatusLab
    }()

    lazy var nodePollsTitleLab: IconLabelView = {
        let nodePollsTitleLab = IconLabelView("我的投票数")
        nodePollsTitleLab.titleLab.textAlignment = .left
        nodePollsTitleLab.titleLab.font = Fonts.Font14
        nodePollsTitleLab.titleLab.textColor  = .white
        return nodePollsTitleLab
    }()

    lazy var nodePollsLab: UILabel = {
        let nodePollsLab = UILabel()
        nodePollsLab.textAlignment = .left
        nodePollsLab.font = Fonts.Font16_b
        nodePollsLab.textColor  = .white
        nodePollsLab.adjustsFontSizeToFitWidth = true
        return nodePollsLab
    }()

    lazy var voteStatusLab: LabelBgView = {
        let voteStatusLab = LabelBgView()
        voteStatusLab.titleLab.textAlignment = .center
        voteStatusLab.titleLab.font = Fonts.Font12
        voteStatusLab.titleLab.textColor  = .white
        return voteStatusLab
    }()

    lazy var operationBtn: UIButton = {
        let operationBtn = UIButton()
        operationBtn.setTitleColor(UIColor.white, for: .normal)
        operationBtn.titleLabel?.font = Fonts.Font14_b
        operationBtn.setBackgroundImage(R.image.background_button_blue()?.tintColor(UIColor(netHex: 0x3460CE)).resizable, for: .normal)
        operationBtn.setBackgroundImage(R.image.background_button_blue()?.tintColor(UIColor(netHex: 0x3460CE)).resizable, for: .highlighted)
        operationBtn.setTitle("撤销", for: .normal)
        operationBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        operationBtn.layer.cornerRadius = 10
        operationBtn.layer.masksToBounds = true
        return operationBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        self._addViewConstraint()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate var voteInfo: VoteInfo?
    fileprivate var voteStatus: VoteStatus?

    func reloadData(_ voteInfo: VoteInfo, _ voteStatus: VoteStatus?) {
        self.voteInfo = voteInfo
        self.voteStatus = voteStatus

        nodeNameLab.text = voteInfo.nodeName
        nodeStatusLab.text = voteInfo.nodeStatus?.display

        nodePollsLab.text =  voteInfo.balance?.amountShort(decimals: TokenCacheService.instance.viteToken.decimals)
        voteStatusLab.titleLab.text = voteStatus?.display

        if  voteStatus == .voting || voteStatus == .cancelVoting {
            operationBtn.isEnabled = true
        } else {
            operationBtn.isEnabled = false
        }
    }

    private func _addViewConstraint() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }

        self.addSubview(nodeNameLab)
        self.addSubview(nodeStatusLab)
        self.addSubview(nodePollsTitleLab)
        self.addSubview(nodePollsLab)
        self.addSubview(voteStatusLab)
        self.addSubview(operationBtn)

        nodeStatusLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(14)
            make.left.equalTo(self).offset(14)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }

        voteStatusLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(14)
            make.right.equalTo(self).offset(-14)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }

        nodeNameLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(61)
            make.left.equalTo(self).offset(14)
            make.right.equalTo(self).offset(-14)
            make.height.equalTo(20)
        }

        nodePollsTitleLab.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.snp.bottom).offset(-16)
            make.left.equalTo(self).offset(14)
            make.height.equalTo(20)
        }
        nodePollsLab.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(nodePollsTitleLab)
            make.left.equalTo(nodePollsTitleLab.snp.right).offset(10)
            make.height.equalTo(20)
            make.right.lessThanOrEqualTo(self).offset(-70)
//            make.width.lessThanOrEqualTo(100)
        }
        operationBtn.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(nodePollsTitleLab)
            make.right.equalTo(self).offset(-14)
            make.height.equalTo(22)
            make.width.equalTo(50)
        }
    }
}
