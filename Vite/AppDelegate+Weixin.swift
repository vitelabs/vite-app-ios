//
//  AppDelegate+Weixin.swift
//  Vite
//
//  Created by Water on 2018/9/28.
//  Copyright © 2018年 vite labs. All rights reserved.
//

extension AppDelegate: WXApiDelegate {

    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpen(url as URL, delegate: self)
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpen(url as URL, delegate: self)
    }
}
