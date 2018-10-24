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
            case test = "test"
            static var name = "DebugPage"
        }

        enum Common {
        }

        enum WalletHome {
            static var name = "Vite_app_wallet_home"
        }

        enum WalletQuota: String {
            case submit = "Vite_app_wallet_quota_SubmitQuota"
            case confirm = "Vite_app_wallet_quota_ConfirmQuota"

            static var name = "Vite_app_wallet_quota"
        }
    }
}
