//
//  MyVoteInfoViewController.swift
//  Vite
//
//  Created by Water on 2018/11/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import BigInt
import RxSwift
import ReactorKit
import RxDataSources

class MyVoteInfoViewController: BaseViewController, View {
    // FIXME: Optional
    let bag = HDWalletManager.instance.bag!
    var disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        self.reactor = MyVoteInfoViewReactor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._setupView()

        self.reactor?.action.onNext(.refreshData)
    }

    private func _setupView() {
        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        view.backgroundColor = .red

        view.addSubview(self.viewInfoView)
        self.viewInfoView.snp.makeConstraints { (make) in
            make.left.top.equalTo(view)
        }
    }

    lazy var viewInfoView: ViewInfoView = {
        let viewInfoView = ViewInfoView()
        return viewInfoView
    }()
}

extension MyVoteInfoViewController {
    func bind(reactor: MyVoteInfoViewReactor) {

        //handle cancel vote
         self.viewInfoView.operationBtn.rx.tap.bind {_ in
            reactor.action.onNext(.cancelVote)
         }.disposed(by: rx.disposeBag)

        //handle new vote data coming
        reactor.state
            .map { $0.voteInfo }
            .bind {
                self.viewInfoView.reloadData($0, $0?.nodeStatus == .invalid ? .voteInvalid : .voteSuccess)
            }.disposed(by: disposeBag)

        //handle error message 
        reactor.state
            .map { $0.errorMessage }
            .filterNil()
            .bind { Toast.show($0) }
            .disposed(by: disposeBag)
    }
}
