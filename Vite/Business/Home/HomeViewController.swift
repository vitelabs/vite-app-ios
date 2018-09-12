//
//  HomeViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Then

class HomeViewController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)

        let walletVC = WalletHomeViewController().then {
            $0.automaticallyShowDismissButton = false
        }

        let myVC = MyHomeViewController()

        let walletNav = BaseNavigationController(rootViewController: walletVC).then {
            $0.tabBarItem.title = R.string.localizable.tabbarItemTitleWallet()
            $0.tabBarItem.image = R.image.bar_icon_wallet()
        }

        let myNav = BaseNavigationController(rootViewController: myVC).then {
            $0.tabBarItem.title = R.string.localizable.tabbarItemTitleMy()
            $0.tabBarItem.image = R.image.bar_icon_my()
        }

        self.viewControllers = [walletNav, myNav]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
