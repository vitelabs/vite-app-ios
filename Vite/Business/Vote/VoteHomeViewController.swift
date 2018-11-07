//
//  VoteHomeViewController.swift
//  Vite
//
//  Created by Water on 2018/11/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

class VoteHomeViewController: BaseViewController {

    let voteListVC = VoteListViewController()
    let  myVoteInfoVC = MyVoteInfoViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self._addViewConstraint()
    }

    func _addViewConstraint() {
        view.backgroundColor = .white

        view.addSubview(myVoteInfoVC.view)
        view.addSubview(voteListVC.view)

        myVoteInfoVC.view.snp.makeConstraints { (make) -> Void in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(200)
        }
        voteListVC.view.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(myVoteInfoVC.view.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(200)
        }
    }
}
