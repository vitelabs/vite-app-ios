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
import NSObject_Rx

class LoginViewController: BaseViewController {

    fileprivate var viewModel: LoginVM

    init() {
        self.viewModel = LoginVM.init()
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

    private func _bindViewModel() {
        self.viewModel.createAccountBtnStr.asObservable().subscribe(onNext: { [weak self] (title) in
            guard let `self` = self else { return }
            self.createAccountBtn.setTitle(title, for: .normal)
        }).disposed(by: rx.disposeBag)

        self.viewModel.recoverAccountBtnStr.asObservable().subscribe(onNext: { [weak self] (title) in
            guard let `self` = self else { return }
            self.importAccountBtn.setTitle(title, for: .normal)
        }).disposed(by: rx.disposeBag)

        self.viewModel.changeLanguageBtnStr.asObservable().subscribe(onNext: { [weak self] (title) in
            guard let `self` = self else { return }
            self.changeLanguageBtn.setTitle(title, for: .normal)
        }).disposed(by: rx.disposeBag)
    }

    lazy var logoImg: UIImageView = {
        let logoImg = UIImageView()
        logoImg.backgroundColor = .clear
        logoImg.image =  R.image.launch_screen_logo()
        return logoImg
    }()

var dd = R.string.localizable.cancel

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
        changeLanguageBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        changeLanguageBtn.setTitleColor(.black, for: .normal)
        changeLanguageBtn.backgroundColor = .orange
        changeLanguageBtn.addTarget(self, action: #selector(changeLanguageBtnAction), for: .touchUpInside)
        return changeLanguageBtn
    }()
}

extension LoginViewController {
    private func _setupView() {
        self.view.backgroundColor = .white

        self._addViewConstraint()
    }

    private func _addViewConstraint() {
        self.view.addSubview(self.logoImg)
        self.logoImg.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.height.equalTo(150)
        }

        self.view.addSubview(self.createAccountBtn)
        self.createAccountBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-30)
            make.left.equalTo(self.view).offset(30)
        }

        self.view.addSubview(self.importAccountBtn)
        self.importAccountBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view).offset(-30)
            make.right.equalTo(self.view).offset(-30)
        }

        self.view.addSubview(self.changeLanguageBtn)
        self.changeLanguageBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60)
            make.height.equalTo(50)
            make.right.equalTo(self.view).offset(-30)
            make.top.equalTo(self.view).offset(100)
        }
    }

    @objc func createAccountBtnAction() {
        let backupMnemonicCashVC = BackupMnemonicViewController()
        self.navigationController?.pushViewController(backupMnemonicCashVC, animated: true)
    }

    @objc func importAccountBtnAction() {
        let backupMnemonicCashVC = BackupMnemonicViewController()
        self.navigationController?.pushViewController(backupMnemonicCashVC, animated: true)
    }

    @objc func changeLanguageBtnAction() {
        let alertController = UIAlertController.init()
        let cancelAction = UIAlertAction(title: LocalizationStr("Cancel"), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let languages: [Language] = SettingDataService.sharedInstance.getSupportedLanguages()
        for element in languages {
            let action = UIAlertAction(title: element.displayName, style: .destructive, handler: {_ in
                 _ = SetLanguage(element.name)
            })
            alertController.addAction(action)
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
