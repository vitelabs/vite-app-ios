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
class ViewInfoView: UIView {
    lazy var nodeNameTitleLab: UILabel = {
        let nodeNameTitleLab = UILabel()
        nodeNameTitleLab.textAlignment = .left
        nodeNameTitleLab.font = Fonts.descFont
        nodeNameTitleLab.textColor  = Colors.titleGray
        nodeNameTitleLab.text =  "节点名称"
        return nodeNameTitleLab
    }()

    lazy var nodeNameLab: UILabel = {
        let nodeNameLab = UILabel()
        nodeNameLab.textAlignment = .left
        nodeNameLab.font = Fonts.descFont
        nodeNameLab.textColor  = Colors.titleGray
        nodeNameLab.text =  ""
        return nodeNameLab
    }()

    lazy var nodeStatusTitleLab: UILabel = {
        let nodeStatusTitleLab = UILabel()
        nodeStatusTitleLab.textAlignment = .left
        nodeStatusTitleLab.font = Fonts.descFont
        nodeStatusTitleLab.textColor  = Colors.titleGray
        nodeStatusTitleLab.text =  "节点状态"
        return nodeStatusTitleLab
    }()

    lazy var nodeStatusLab: UILabel = {
        let nodeStatusLab = UILabel()
        nodeStatusLab.textAlignment = .left
        nodeStatusLab.font = Fonts.descFont
        nodeStatusLab.textColor  = Colors.titleGray
        nodeStatusLab.text =  ""
        return nodeStatusLab
    }()

    lazy var nodePollsTitleLab: UILabel = {
        let nodePollsTitleLab = UILabel()
        nodePollsTitleLab.textAlignment = .left
        nodePollsTitleLab.font = Fonts.descFont
        nodePollsTitleLab.textColor  = Colors.titleGray
        nodePollsTitleLab.text =  "当前投票数"
        return nodePollsTitleLab
    }()

    lazy var nodePollsLab: UILabel = {
        let nodePollsLab = UILabel()
        nodePollsLab.textAlignment = .left
        nodePollsLab.font = Fonts.descFont
        nodePollsLab.textColor  = Colors.titleGray
        nodePollsLab.text =  ""
        return nodePollsLab
    }()

    lazy var voteStatusTitleLab: UILabel = {
        let voteStatusTitleLab = UILabel()
        voteStatusTitleLab.textAlignment = .left
        voteStatusTitleLab.font = Fonts.descFont
        voteStatusTitleLab.textColor  = Colors.titleGray
        voteStatusTitleLab.text =  "投票状态"
        return voteStatusTitleLab
    }()

    lazy var voteStatusLab: UILabel = {
        let voteStatusLab = UILabel()
        voteStatusLab.textAlignment = .left
        voteStatusLab.font = Fonts.descFont
        voteStatusLab.textColor  = Colors.titleGray
        voteStatusLab.text =  ""
        return voteStatusLab
    }()

    lazy var operationTitleLab: UILabel = {
        let operationTitleLab = UILabel()
        operationTitleLab.textAlignment = .left
        operationTitleLab.font = Fonts.descFont
        operationTitleLab.textColor  = Colors.titleGray
        operationTitleLab.text =  "操作"
        return operationTitleLab
    }()

    lazy var operationBtn: UIButton = {
        let operationBtn = UIButton.init(style: .whiteWithoutShadow)
        operationBtn.setTitle("撤销", for: .normal)
        operationBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
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

    func handleEmptyData(_ isHidden: Bool) {
        nodePollsTitleLab.isHidden = isHidden
        voteStatusTitleLab.isHidden = isHidden
        operationTitleLab.isHidden = isHidden

        nodePollsLab.isHidden = isHidden
        voteStatusLab.isHidden = isHidden
        operationBtn.isHidden = isHidden
    }

    func reloadData(_ voteInfo: VoteInfo?, _ voteStatus: VoteStatus?) {
        self.voteInfo = voteInfo
        self.voteStatus = voteStatus

        guard let voteInfo = self.voteInfo else {
            self.handleEmptyData(true)
            return
        }
        self.handleEmptyData(false)
        nodeNameLab.text = voteInfo.nodeName
        nodeStatusLab.text = voteInfo.nodeStatus?.display

        nodePollsLab.text =  voteInfo.balance?.amountShort(decimals: TokenCacheService.instance.viteToken.decimals)
        voteStatusLab.text = voteStatus?.display

        if  voteStatus == .voting || voteStatus == .cancelVoting {
            operationBtn.isEnabled = true
        } else {
            operationBtn.isEnabled = false
        }
    }

    private func _addViewConstraint() {
        self.addSubview(nodeNameTitleLab)
        self.addSubview(nodeNameLab)

        self.addSubview(nodeStatusTitleLab)
        self.addSubview(nodeStatusLab)

        self.addSubview(nodePollsTitleLab)
        self.addSubview(nodePollsLab)

        self.addSubview(voteStatusTitleLab)
        self.addSubview(voteStatusLab)

        self.addSubview(operationTitleLab)
        self.addSubview(operationBtn)

        nodeNameTitleLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        nodeNameLab.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(nodeNameTitleLab)
            make.left.equalTo(nodeNameTitleLab.snp.right).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }

        nodeStatusTitleLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nodeNameTitleLab.snp.bottom)
            make.left.equalTo(self)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        nodeStatusLab.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(nodeStatusTitleLab)
            make.left.equalTo(nodeStatusTitleLab.snp.right).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }

        nodePollsTitleLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nodeStatusTitleLab.snp.bottom)
            make.left.equalTo(self)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        nodePollsLab.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(nodePollsTitleLab)
            make.left.equalTo(nodePollsTitleLab.snp.right).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }

        voteStatusTitleLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nodePollsTitleLab.snp.bottom)
            make.left.equalTo(self)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        voteStatusLab.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(voteStatusTitleLab)
            make.left.equalTo(voteStatusTitleLab.snp.right).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }

        operationTitleLab.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(voteStatusTitleLab.snp.bottom)
            make.left.equalTo(self)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        operationBtn.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(operationTitleLab)
            make.left.equalTo(operationTitleLab.snp.right).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
    }
}
