//
//  Alert.swift
//  Vite
//
//  Created by Stone on 2018/9/19.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

struct Alert {
    @discardableResult
    public static func show(into viewController: UIViewController,
                            title: String?,
                            message: String?,
                            actions: [(UIAlertControllerAletrActionTitle, ((UIAlertController) -> Void)?)],
                            config: ((UIAlertController) -> Void)? = nil) -> UIAlertController {

        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for action in actions {
            switch action.0 {
            case .default(let title):
                let action = UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: { (_) in
                    if let action = action.1 { action(alert) }
                })
                alert.addAction(action)
            case .destructive(let title):
                let action = UIAlertAction(title: title, style: UIAlertActionStyle.destructive, handler: { (_) in
                    if let action = action.1 { action(alert) }
                })
                alert.addAction(action)
            case .cancel:
                let action = UIAlertAction(title: R.string.localizable.cancel.key.localized(), style: UIAlertActionStyle.default, handler: { (_) in
                    if let action = action.1 { action(alert) }
                })
                alert.addAction(action)
            case .delete:
                let action = UIAlertAction(title: R.string.localizable.delete.key.localized(), style: UIAlertActionStyle.destructive, handler: { (_) in
                    if let action = action.1 { action(alert) }
                })
                alert.addAction(action)
            }
        }
        alert.preferredAction = alert.actions.last
        if let config = config { config(alert) }
        viewController.present(alert, animated: true, completion: nil)
        return alert
    }

    public enum UIAlertControllerAletrActionTitle {
        case `default`(title: String)
        case destructive(title: String)
        case cancel
        case delete
    }
}
