//
//  Alert.swift
//  Vite
//
//  Created by Stone on 2018/9/19.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

struct DebugActionSheet {
    @discardableResult
    public static func show(title: String?,
                            message: String?,
                            actions: [(Alert.UIAlertControllerAletrActionTitle, ((UIAlertController) -> Void)?)],
                            config: ((UIAlertController) -> Void)? = nil) -> UIAlertController {

        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)

        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return alert }
        var top = rootVC
        while let presentedViewController = top.presentedViewController {
            top = presentedViewController
        }

        for action in actions {
            switch action.0 {
            case .default(let title):
                let action = UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: { [weak alert] (_) in
                    if let action = action.1, let alert = alert { action(alert) }
                })
                alert.addAction(action)
            case .destructive(let title):
                let action = UIAlertAction(title: title, style: UIAlertAction.Style.destructive, handler: { [weak alert] (_) in
                    if let action = action.1, let alert = alert { action(alert) }
                })
                alert.addAction(action)
            case .cancel:
                let action = UIAlertAction(title: R.string.localizable.cancel(), style: UIAlertAction.Style.cancel, handler: { [weak alert] (_) in
                    if let action = action.1, let alert = alert { action(alert) }
                })
                alert.addAction(action)
            case .delete:
                let action = UIAlertAction(title: R.string.localizable.delete(), style: UIAlertAction.Style.destructive, handler: { [weak alert] (_) in
                    if let action = action.1, let alert = alert { action(alert) }
                })
                alert.addAction(action)
            }
        }

        if let config = config { config(alert) }
        top.present(alert, animated: true, completion: nil)
        return alert
    }
}

struct Alert {
    @discardableResult
    public static func show(into viewController: UIViewController? = nil,
                            title: String?,
                            message: String?,
                            actions: [(UIAlertControllerAletrActionTitle, ((AlertControl) -> Void)?)],
                            config: ((AlertControl) -> Void)? = nil) -> AlertControl {

        let alert = AlertControl.init(title: title, message: message, style: .alert)
        for action in actions {
            switch action.0 {
            case .default(let title):
                let action = AlertAction(title: title, style: .light, handler: { alert in
                    if let action = action.1 { action(alert) }
                })
                alert.addAction(action)
            case .destructive(let title):
                let action = AlertAction(title: title, style: .light, handler: { alert in
                    if let action = action.1 { action(alert) }
                })
                alert.addAction(action)
            case .cancel:
                let action = AlertAction(title: R.string.localizable.cancel(), style: .light, handler: { alert in
                    if let action = action.1 { action(alert) }
                })
                alert.addCancelAction(action)
            case .delete:
                let action = AlertAction(title: R.string.localizable.delete(), style: .light, handler: { alert in
                    if let action = action.1 { action(alert) }
                })
                alert.addAction(action)
            }
        }
        alert.preferredAction = alert.actions.last
        if let config = config { config(alert) }
        alert.show()
        return alert
    }

    public enum UIAlertControllerAletrActionTitle {
        case `default`(title: String)
        case destructive(title: String)
        case cancel
        case delete
    }
}

struct AlertSheet {
    @discardableResult
    public static func show(into viewController: UIViewController? = nil,
                            title: String?,
                            message: String?,
                            actions: [(UIAlertControllerAletrActionTitle, ((AlertControl) -> Void)?)],
                            config: ((AlertControl) -> Void)? = nil) -> AlertControl {

        let alert = AlertControl.init(title: title, message: message, style: .actionSheet)
        for action in actions {
            switch action.0 {
            case .default(let title):
                let action = AlertAction(title: title, style: .light, handler: { alert in
                    if let action = action.1 { action(alert) }
                })
                alert.addAction(action)
            case .destructive(let title):
                let action = AlertAction(title: title, style: .light, handler: { alert in
                    if let action = action.1 { action(alert) }
                })
                alert.addAction(action)
            case .cancel:
                let action = AlertAction(title: R.string.localizable.cancel(), style: .light, handler: { alert in
                    if let action = action.1 { action(alert) }
                })
                alert.addCancelAction(action)
            case .delete:
                let action = AlertAction(title: R.string.localizable.delete(), style: .light, handler: { alert in
                    if let action = action.1 { action(alert) }
                })
                alert.addAction(action)
            }
        }
        alert.preferredAction = alert.actions.last
        if let config = config { config(alert) }
        alert.show()
        return alert
    }

    public enum UIAlertControllerAletrActionTitle {
        case `default`(title: String)
        case destructive(title: String)
        case cancel
        case delete
    }
}
