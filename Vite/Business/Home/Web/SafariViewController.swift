//
//  SafariViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: SFSafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredControlTintColor = UIColor(netHex: 0x007AFF)
        if #available(iOS 11.0, *) {
            dismissButtonStyle = .close
        }
    }
}
