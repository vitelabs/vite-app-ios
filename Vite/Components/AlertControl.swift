//
//  AlertControl.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/19.
//  Copyright © 2018 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class AlertAction: NSObject {

    enum Style: Int {
        case emphasize
        case light
    }

    let title: String?
    var style: Style?
    let handler: ((AlertControl) -> Void)?

    init(title: String? = nil, style: Style? = nil, handler: ((AlertControl) -> Void)?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

class AlertControl: UIViewController {

    var alertTitle: String?
    var message: String?
    var preferredAction: AlertAction?
    var textFields: [UITextField]? = []
    var actions: [AlertAction] = []
    var cancelAction: AlertAction?
    var window: UIWindow {
        return UIApplication.shared.keyWindow!
    }
    fileprivate var selfReference: AlertControl?
    fileprivate var contentView: UIView?
    var style: UIAlertController.Style

    init(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert) {
        self.alertTitle = title
        self.message = message
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }

    func addAction(_ action: AlertAction) {
        actions.append(action)
    }

    func addCancelAction(_ action: AlertAction) {
        if self.style == .actionSheet && self.cancelAction != nil {
            fatalError("already have cancelAction")
        }
        actions.append(action)
        cancelAction = action
    }

    func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.init(netHex: 0x8E8E93).cgColor
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.leftView = UIView().then {
            $0.frame = CGRect.init(x: 0, y: 0, width: 5, height: 20)
        }
        textField.leftViewMode = .always
        configurationHandler?(textField)
        self.textFields?.append(textField)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        selfReference = self
        window.addSubview(view)
        view.frame = window.bounds
        view.backgroundColor = UIColor.init(hex: "0x000000", alpha: 0.0)
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = UIColor.init(hex: "0x000000", alpha: 0.5)
        }

        for action in actions where action == self.preferredAction {
            action.style = .emphasize
            break
        }

        //根据UI规范，弹框样式目前只支持两个按钮。故转成actionsheet样式
        if self.actions.count > 2 {
            self.style = .actionSheet
        }

        if self.style == .actionSheet {
            showAlerSheet()
        } else {
            showAlertCommenView()
        }

    }

    fileprivate func showAlerSheet() {
        let filtedActions = actions.filter { (action) -> Bool in
            return action != self.cancelAction
        }
        let alertSheetView = AlertSheetView.init(title: alertTitle, message: message, actions: filtedActions)
        view.addSubview(alertSheetView)
        contentView = alertSheetView
        alertSheetView.snp.makeConstraints { (m) in
            m.bottom.left.right.equalToSuperview()
        }

        alertSheetView.transform = CGAffineTransform.init(translationX: 0, y: 100)

        for (i, b) in alertSheetView.actionButtons.enumerated() {
            b.rx.tap.bind { [unowned self] in
                self.disMiss(completion: {
                    filtedActions[i].handler?(self)
                })
            }.disposed(by: rx.disposeBag)
        }

        alertSheetView.closeButton.rx.tap.bind { [unowned self] in
            self.disMiss(completion: {
                self.cancelAction?.handler?(self)
            })
        }.disposed(by: rx.disposeBag)

        alertSheetView.closeButton.isHidden = (self.cancelAction == nil)

        UIView.animate(withDuration: 0.2) {
            alertSheetView.transform = .identity
        }
    }

    fileprivate func showAlertCommenView() {

        if self.textFields!.count > 1 {
            fatalError("just support one textField now!")
        }
        if actions.count > 2 {
            fatalError("just support one or two actions")
        }

        let alertCommenView = AlertCommenView.init(title: alertTitle, message: message, textFields: self.textFields!, actions: actions)
        view.addSubview(alertCommenView)
        contentView = alertCommenView
        alertCommenView.snp.makeConstraints { (m) in
            m.center.equalTo(view)
        }

        for (i, b) in alertCommenView.actionButtons.enumerated() {
            b.rx.tap.bind { [unowned self] in
                self.disMiss(completion: {
                    self.actions[i].handler?(self)
                })
            }.disposed(by: rx.disposeBag)
        }

        Observable.merge([
            NotificationCenter.default.rx.notification(.UIKeyboardWillHide),
            NotificationCenter.default.rx.notification(.UIKeyboardWillShow)
            ])
            .subscribe(onNext: {[unowned alertCommenView] (notification) in
                let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
                let height =  (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height / 3.0
                UIView.animate(withDuration: duration, animations: {
                    if notification.name == .UIKeyboardWillShow && alertCommenView.textFields?.first?.isFirstResponder ?? false {
                        alertCommenView.transform = CGAffineTransform(translationX: 0, y: -height)
                    } else if notification.name == .UIKeyboardWillHide {
                        alertCommenView.transform = .identity
                    }
                })
            }).disposed(by: rx.disposeBag)

        self.textFields?.first?.becomeFirstResponder()

        alertCommenView.alpha = 0.0
        UIView.animate(withDuration: 0.2) {
            alertCommenView.alpha = 1
        }
    }

    func disMiss(completion:(() -> Void)?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.backgroundColor = UIColor.init(hex: "0x000000", alpha: 0.0)
            self.contentView?.alpha = 0.0
        }, completion: { _ in
            self.view.removeFromSuperview()
            self.selfReference = nil
            completion?()
        })
    }
}

extension AlertControl {
    class func showCompletion(_ title: String) {
        let vc = AlertControl()
        vc.window.addSubview(vc.view)
        vc.selfReference = vc
        vc.view.frame = vc.window.bounds
        vc.view.backgroundColor = UIColor.init(hex: "0x000000", alpha: 0.5)
        let alertCompletionView = AlertCompletionView.init(title: title)
        vc.view.addSubview(alertCompletionView)
        vc.contentView = alertCompletionView
        alertCompletionView.snp.makeConstraints { (m) in
            m.width.equalTo(270)
            m.height.equalTo(140)
            m.center.equalToSuperview()
        }
        GCD.delay(2) {
            vc.disMiss(completion: nil)
        }
    }
}

private class AlertCompletionView: UIView {

    let imageView = UIImageView().then {
        $0.image = R.image.success()
    }

    let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }

    init(title: String?) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 270, height: 140))
        self.layer.cornerRadius = 2
        self.backgroundColor = UIColor.init(netHex: 0xFFFFFF)
        titleLabel.text = title
        self.addSubview(imageView)
        self.addSubview(titleLabel)

        imageView.snp.makeConstraints { (m) in
            m.top.equalToSuperview().offset(23)
            m.centerX.equalToSuperview()
            m.width.equalTo(54)
            m.height.equalTo(52)
        }
        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(imageView.snp.bottom).offset(25)
            m.left.right.equalToSuperview()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private class AlertCommenView: UIView {

    lazy var titleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    lazy var messageLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.init(netHex: 0x3e4a59)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    var textFields: [UITextField]?
    var actionButtons = [UIButton]()

    init(title: String?, message: String?, textFields: [UITextField]?, actions: [AlertAction]) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: 270, height: 151))
        self.layer.cornerRadius = 2
        self.backgroundColor = UIColor.init(netHex: 0xFFFFFF)
        self.textFields = textFields

        var v: UIView? = self
        var topMargen = 24.0
        var hegith = topMargen

        if title != nil {
            titleLabel.text = title
            self.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (m) in
                m.top.equalTo(v!).offset(24)
                m.left.equalTo(self).offset(16)
                m.right.equalTo(self).offset(-16)
            }
            v = titleLabel
            let suggestedTitleLabelSize = titleLabel.sizeThatFits(CGSize(width: 270 - 16 * 2, height: kScreenH / 2))
            hegith +=  (topMargen + Double(suggestedTitleLabelSize.height))
            topMargen = 12
        }

        if message != nil {
            messageLabel.text = message
            self.addSubview(messageLabel)
            messageLabel.snp.makeConstraints { (m) in
                m.top.equalTo(v!.snp.bottom).offset(topMargen)
                m.left.equalTo(self).offset(16)
                m.right.equalTo(self).offset(-16)
            }
            v = messageLabel
            let suggestedMessageLabelSize = messageLabel.sizeThatFits(CGSize(width: 270 - 16 * 2, height: kScreenH / 2))
            hegith += topMargen + Double(suggestedMessageLabelSize.height)
            topMargen = 12
        }

        if let textField = self.textFields?.first {
            self.addSubview(textField)
            textField.snp.makeConstraints { (m) in
                m.left.equalToSuperview().offset(16)
                m.right.equalToSuperview().offset(-16)
                m.top.equalTo(v!.snp.bottom).offset(topMargen)
                m.height.equalTo(25)
            }
            v = textField
            hegith += topMargen + 25
            topMargen = 12
        }

        let horizontalSeperator = UIView().then { $0.backgroundColor = UIColor.init(netHex: 0x000050, alpha: 0.05) }
        let verticalSeperator = UIView().then { $0.backgroundColor = UIColor.init(netHex: 0x000050, alpha: 0.05) }
        self.addSubview(horizontalSeperator)
        self.addSubview(verticalSeperator)
        horizontalSeperator.snp.makeConstraints { (m) in
            m.left.right.equalToSuperview()
            m.height.equalTo(1)
            m.top.equalTo(v!.snp.bottom).offset(topMargen)
        }
        verticalSeperator.snp.makeConstraints { (m) in
            m.centerX.equalToSuperview()
            m.width.equalTo(1)
            m.top.equalTo(horizontalSeperator)
            m.bottom.equalToSuperview()
        }

        actionButtons = actions.map { action in
            let button = UIButton()
            button.setTitleColor(UIColor.init(netHex: 0x007AFF), for: .normal)
            button.setTitle(action.title, for: .normal)
            if action.style == .emphasize {
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            }
            self.addSubview(button)
            return button
        }

        if actionButtons.count == 1 {
            actionButtons.first!.snp.makeConstraints { (m) in
                m.left.right.bottom.equalToSuperview()
                m.height.equalTo(43)
            }
            verticalSeperator.isHidden = true
        } else if actionButtons.count == 2 {
            actionButtons.first!.snp.makeConstraints { (m) in
                m.left.bottom.equalToSuperview()
                m.height.equalTo(43)
                m.width.equalTo(134)
            }
            actionButtons.last!.snp.makeConstraints { (m) in
                m.right.bottom.equalToSuperview()
                m.height.equalTo(43)
                m.width.equalTo(134)
            }
        }
        hegith += 32

        self.snp.makeConstraints { (m) in
            m.height.equalTo(hegith)
            m.width.equalTo(270)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private class AlertSheetView: UIView {

    let closeButton = UIButton().then {
        $0.setImage(R.image.icon_nav_close_black(), for: .normal)
    }

    var actionButtons = [UIButton]()

    let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 17)
    }

    let messageLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }

    init(title: String?, message: String?, actions: [AlertAction]) {
        super.init(frame: .zero)

        titleLabel.text = title
        messageLabel.text = message
        actionButtons = actions.map { action in
            let button = UIButton()
            if action.style == .light {
                button.layer.borderColor = UIColor.init(netHex: 0x007AFF).cgColor
                button.layer.borderWidth = 1
                button.setTitleColor(UIColor.init(netHex: 0x007AFF), for: .normal)
            } else if action.style == .emphasize {
                button.backgroundColor = UIColor.init(netHex: 0x007AFF)
            }
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.layer.cornerRadius = 2.0
            button.setTitle(action.title, for: .normal)
            return button
        }

        var topMostButton: UIButton?
        for b in actionButtons.reversed() {
            self.addSubview(b)
            b.snp.makeConstraints { (m) in
                m.width.equalTo(kScreenW - 24 * 2)
                m.height.equalTo(50)
                m.centerX.equalTo(self)
                if let topMostButton = topMostButton {
                    m.bottom.equalTo(topMostButton.snp.top).offset(-20)
                } else {
                    m.bottom.equalTo(self.snp.bottom).offset(-24)
                }
            }
            topMostButton = b
        }

        self.addSubview(messageLabel)
        self.addSubview(titleLabel)
        self.addSubview(closeButton)

        messageLabel.snp.makeConstraints { (m) in
            m.width.equalTo(kScreenW - 24 * 2)
            m.centerX.equalTo(self)
            m.bottom.equalTo((topMostButton != nil) ? topMostButton!.snp.top : self.safeAreaLayoutGuideSnpBottom).offset(-24)
            m.top.equalTo(titleLabel.snp.bottom).offset(30)
        }

        closeButton.snp.makeConstraints { (m) in
            m.width.height.equalTo(28)
            m.left.equalToSuperview().offset(24)
            m.centerY.equalTo(titleLabel)
        }

        titleLabel.snp.makeConstraints { (m) in
            m.width.equalTo(kScreenW - 24 * 4)
            m.centerX.equalTo(self)
            m.top.equalTo(self.snp.top).offset(19)
        }

        let suggestedViewTextSize = messageLabel.sizeThatFits(CGSize(width: kScreenW - 24 * 2, height: CGFloat.greatestFiniteMagnitude))
        let height = 100 +  70.0 * Double(actions.count) + Double(suggestedViewTextSize.height)

        self.snp.makeConstraints { (m) in
            m.width.equalTo(kScreenW)
            m.height.equalTo(height)
        }

        self.backgroundColor = UIColor.init(netHex: 0xffffff, alpha: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
