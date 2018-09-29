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
    #if DEBUG
    public static let viteCentralizedHost = "http://132.232.138.139:8080"
    #else
    public static let viteCentralizedHost = "http://119.28.221.127:8080"
    #endif
    //weixinAppID
    public static let weixinAppID = "wx7e5f2476e871c244"
    //weixin Official Accounts AppID
    public static let officialAccountsAppID = "gh_50e071040bca"
}
