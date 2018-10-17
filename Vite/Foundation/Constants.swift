//
//  Constants.swift
//  Vite
//
//  Created by Water on 2018/9/21.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

public struct Constants {
    // support
    public static let supportEmail = "info@vite.org"
    //baidu  statistics
    public static let baiduMobileStat = "e74c7f32c0"
    //vite  centralized  host
    public static let viteCentralizedHost = "https://testnet.vite.net"
    //weixinAppID
    public static let weixinAppID = "wx7e5f2476e871c244"
    //weixin Official Accounts AppID
    public static let officialAccountsAppID = "gh_50e071040bca"
    //app channel
    #if RELEASE_INHOUSE_FOR_DISTRIBUTE
    public static let appDownloadChannel = "enterprise"
    #else
    public static let appDownloadChannel = "appstore"
    #endif

}
