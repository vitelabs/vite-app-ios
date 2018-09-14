//
//  BaseNavigationController.swift
//  Vite
//
//  Created by Stone on 2018/8/27.
//  Copyright © 2018年 Vite. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }

        super.pushViewController(viewController, animated: animated)
    }

}

extension BaseNavigationController: UINavigationControllerDelegate {

    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }

    override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
