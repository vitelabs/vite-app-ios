//
//  HomeViewController.swift
//  Vite
//
//  Created by Water on 2018/8/16.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    let walletManageBtn = UIButton()
    let changeLanguageBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        walletManageBtn.setTitle("备份助记词", for: .normal)
        walletManageBtn.setTitleColor(.black, for: .normal)
        walletManageBtn.backgroundColor = .orange
        walletManageBtn.addTarget(self, action: #selector(walletManageBtnAction), for: .touchUpInside)
        self.view.addSubview(walletManageBtn)
        walletManageBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.top.left.equalTo(self.view).offset(100)
        }


        changeLanguageBtn.setTitle(SettingDataService.sharedInstance.getCurrentLanguage().displayName, for: .normal)
        changeLanguageBtn.setTitleColor(.black, for: .normal)
        changeLanguageBtn.backgroundColor = .orange
        changeLanguageBtn.addTarget(self, action: #selector(changeLanguageBtnAction), for: .touchUpInside)
        self.view.addSubview(changeLanguageBtn)
        changeLanguageBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(100)
            make.bottom.equalTo(self.view).offset(-100)
        }
    }

    @objc func walletManageBtnAction() {
        let backupMnemonicCashVC = BackupMnemonicViewController()
        self.navigationController?.pushViewController(backupMnemonicCashVC, animated: true)
    }

    @objc func changeLanguageBtnAction() {
        let actionSheet=UIActionSheet()

        actionSheet.title = "请选择操作"

//        SettingDataService.sharedInstance.getSupportedLanguages().map { () -> T in
//
//        }


//         getSupportedLanguages
//        actionSheet.addButton(withTitle: )
//
//        actionSheet.addButtonWithTitle("取消")
//        actionSheet.addButtonWithTitle("动作1")
//        actionSheet.addButtonWithTitle("动作2")
//        actionSheet.cancelButtonIndex=0
//        actionSheet.delegate=self
//        actionSheet.showInView(self.view);

    }


    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
//        print("点击了："+actionSheet.buttonTitleAtIndex(buttonIndex)!)
    }


}
