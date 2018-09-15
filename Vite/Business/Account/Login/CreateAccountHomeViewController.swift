//
//  LoginViewController.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class CreateAccountHomeViewController: BaseViewController {
    fileprivate var viewModel: CreateAccountHomeVM

    init() {
        self.viewModel = CreateAccountHomeVM()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
        self._bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func _bindViewModel() {
        _ = self.viewModel.createAccountBtnStr.asObservable().bind(to: self.createAccountBtn.rx.title(for: .normal))
        _ = self.viewModel.recoverAccountBtnStr.asObservable().bind(to: self.importAccountBtn.rx.title(for: .normal))
        _ = self.viewModel.changeLanguageBtnStr.asObservable().bind(to: self.changeLanguageBtn.rx.title(for: .normal))
    }

    lazy var createAccountBtn: UIButton = {
        let createAccountBtn = UIButton.init(style: .blue)
        createAccountBtn.setTitle(R.string.localizable.createAccount.key.localized(), for: .normal)
        createAccountBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        createAccountBtn.addTarget(self, action: #selector(createAccountBtnAction), for: .touchUpInside)
        return createAccountBtn
    }()

    lazy var importAccountBtn: UIButton = {
        let importAccountBtn = UIButton.init(style: .white)
        importAccountBtn.setTitle(R.string.localizable.importAccount.key.localized(), for: .normal)
        importAccountBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        importAccountBtn.addTarget(self, action: #selector(importAccountBtnAction), for: .touchUpInside)
        return importAccountBtn
    }()

    lazy var changeLanguageBtn: UIButton = {
        let changeLanguageBtn = UIButton()
        changeLanguageBtn.contentHorizontalAlignment = .right
        changeLanguageBtn.contentVerticalAlignment = .top
        changeLanguageBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        changeLanguageBtn.setTitleColor(.white, for: .normal)
        changeLanguageBtn.backgroundColor = .clear
        changeLanguageBtn.titleLabel?.font = AppStyle.descWord.font
        changeLanguageBtn.addTarget(self, action: #selector(changeLanguageBtnAction), for: .touchUpInside)
        return changeLanguageBtn
    }()
}

extension CreateAccountHomeViewController {
    private func _setupView() {
        self.view.backgroundColor = .clear

        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        let bgImgView = UIImageView.init(image: R.image.login_bg())
        self.view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }

        let logoImgView = UIImageView.init(image: R.image.icon_vite_logo())
        let sloganImgView = UIImageView.init(image: R.image.splash_slogen())
        self.view.addSubview(logoImgView)
        logoImgView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(30)
            make.top.equalTo(self.view).offset(100)
        }
        self.view.addSubview(sloganImgView)
        sloganImgView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-60)
            make.top.equalTo(logoImgView.snp.bottom).offset(50)
        }

        self.view.addSubview(self.importAccountBtn)
        self.importAccountBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-(24+Safe_Area_Bottom_Height))
        }

        self.view.addSubview(self.createAccountBtn)
        self.createAccountBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.height.equalTo(50)
            make.bottom.equalTo(self.importAccountBtn.snp.top).offset(-20)
        }

        self.view.addSubview(self.changeLanguageBtn)
        self.changeLanguageBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.right.equalTo(self.view).offset(-24)
            make.top.equalTo(self.view).offset(32)
        }
    }

    @objc func createAccountBtnAction() {
        let vc = CreateWalletAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func importAccountBtnAction() {
        let vc = ImportAccountViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func changeLanguageBtnAction() {
        self.showChangeLanguageList()
    }
}
