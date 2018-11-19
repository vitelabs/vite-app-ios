//
//  Statistics+Event.swift
//  Vite
//
//  Created by Stone on 2018/10/23.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

extension Statistics {

    enum Page {

        enum Debug: String {
            case test = "debug_page_test"
            static var name = "debug_page"
        }

        enum Common {
        }

        enum WalletHome {
            static var name = "wallet_home_page"
        }

        enum WalletQuota: String {
            case submit = "wqp_submit_quota"
            case confirm = "wqp_confirm_quota"

            static var name = "wallet_quota_page"
        }
    }
}
