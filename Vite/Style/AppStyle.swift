//
//  AppStyle.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

// screen height
let kScreenH = UIScreen.main.bounds.height
// screen width
let kScreenW = UIScreen.main.bounds.width
//Adaptive iPhoneX
let is_iPhoneX = (kScreenW == 375.0 && kScreenH == 812.0 ? true : false)
let kNavibarH: CGFloat = is_iPhoneX ? 88.0 : 64.0
let kTabbarH: CGFloat = is_iPhoneX ? 49.0+34.0 : 49.0
let kStatusbarH: CGFloat = is_iPhoneX ? 44.0 : 20.0
let iPhoneXBottomH: CGFloat = 34.0
let iPhoneXTopH: CGFloat = 24.0

enum AppStyle {
    case inputDescWord
    case descWord
    case heading
    case headingSemiBold
    case paragraph
    case paragraphLight
    case paragraphSmall
    case largeAmount
    case error
    case formHeader
    case collactablesHeader

    var font: UIFont {
        switch self {
        case .inputDescWord:
            return UIFont.systemFont(ofSize: 18, weight: .regular)
        case .descWord:
            return UIFont.systemFont(ofSize: 16, weight: .regular)
        case .heading:
            return UIFont.systemFont(ofSize: 18, weight: .regular)
        case .headingSemiBold:
            return UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .paragraph:
            return UIFont.systemFont(ofSize: 15, weight: .regular)
        case .paragraphSmall:
            return UIFont.systemFont(ofSize: 14, weight: .regular)
        case .paragraphLight:
            return UIFont.systemFont(ofSize: 15, weight: .light)
        case .largeAmount:
            return UIFont.systemFont(ofSize: 20, weight: .medium)
        case .error:
            return UIFont.systemFont(ofSize: 13, weight: .light)
        case .formHeader:
            return UIFont.systemFont(ofSize: 14, weight: .regular)
        case .collactablesHeader:
            return UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.regular)
        }
    }

    var textColor: UIColor {
        switch self {
        case .heading, .headingSemiBold:
            return Colors.darkBlue
        case .paragraph, .paragraphLight, .paragraphSmall:
            return Colors.darkBlue
        case .largeAmount:
            return UIColor.black
        case .error:
            return Colors.darkBlue
        case .formHeader:
            return Colors.darkBlue
        case .collactablesHeader, .inputDescWord:
            return Colors.darkBlue
        case .descWord:
            return Colors.darkGray
        }
    }
}
