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
        self.view.backgroundColor = UIColor.white
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
