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

    lazy var logoImgView: UIImageView = {
        let logoImgView = UIImageView()
        logoImgView.backgroundColor = .clear
        logoImgView.image =  R.image.launch_screen_logo()
        return logoImgView
    }()

    lazy var sloganImgView: UIImageView = {
        let sloganImgView = UIImageView()
        sloganImgView.backgroundColor = .clear
        sloganImgView.image =  R.image.launch_screen_logo()
        return sloganImgView
    }()

    lazy var createAccountBtn: UIButton = {
        let createAccountBtn = UIButton()
        createAccountBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        createAccountBtn.setTitleColor(.black, for: .normal)
        createAccountBtn.backgroundColor = .orange
        createAccountBtn.addTarget(self, action: #selector(createAccountBtnAction), for: .touchUpInside)
        return createAccountBtn
    }()

    lazy var importAccountBtn: UIButton = {
        let importAccountBtn = UIButton()
        importAccountBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        importAccountBtn.setTitleColor(.black, for: .normal)
        importAccountBtn.backgroundColor = .orange
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
        self.view.backgroundColor = .blue

        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        self.view.addSubview(self.logoImgView)
        self.logoImgView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(30)
            make.top.equalTo(self.view).offset(130)
            make.width.height.equalTo(65)
        }

        self.view.addSubview(self.sloganImgView)
        self.sloganImgView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.view).offset(30)
            make.top.equalTo(self.logoImgView.snp.bottom).offset(50)
            make.width.height.equalTo(65)
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
