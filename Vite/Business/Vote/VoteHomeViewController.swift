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
        navigationTitleView = _createNavigationTitleView()
        self._addViewConstraint()
    }

    fileprivate func _createNavigationTitleView() -> UIView {
        let view = UIView().then {
            $0.backgroundColor = UIColor.clear
        }

        let titleLabel = LabelTipView(R.string.localizable.votePageTitle()).then {
            $0.titleLab.font = UIFont.systemFont(ofSize: 24)
            $0.titleLab.textColor = UIColor(netHex: 0x24272B)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(view).offset(6)
            m.left.equalTo(view).offset(24)
            m.bottom.equalTo(view).offset(-20)
            m.height.equalTo(29)
        }

        titleLabel.tipButton.rx.tap.bind {
            let url  = URL(string: String(format: "%@?localize=%@", Constants.voteDefinitionURL, LocalizationService.sharedInstance.currentLanguage.rawValue))!
            let vc = PopViewController(url: url)
            vc.modalPresentationStyle = .overCurrentContext
            let delegate =  StyleActionSheetTranstionDelegate()
            vc.transitioningDelegate = delegate

            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
        }.disposed(by: rx.disposeBag)
        return view
    }

    fileprivate func _addViewConstraint() {
        view.backgroundColor = .white

        let shadowView = UIView().then {
            $0.backgroundColor = UIColor.white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 10)
            $0.layer.shadowRadius = 20
        }

        view.addSubview(shadowView)
        shadowView.snp.makeConstraints { (m) in
            m.left.top.right.equalTo(view)
            m.top.equalTo(view)
            m.height.equalTo(118)
        }

        self.addChild(voteListVC)
        self.addChild(myVoteInfoVC)
        voteListVC.didMove(toParent: self)
        myVoteInfoVC.didMove(toParent: self)
        view.addSubview(myVoteInfoVC.view)
        view.addSubview(voteListVC.view)

        myVoteInfoVC.view.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.navigationTitleView!.snp.bottom)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(128)
        }
        voteListVC.view.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(myVoteInfoVC.view.snp.bottom).offset(20)
            make.left.right.bottom.equalTo(self.view)
        }
    }
}
