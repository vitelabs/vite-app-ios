//
//  UITextField+FDSKeyboardAutoScrolling.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

private var kkas_returnAction: UInt8 = 0
private var kkas_textFieldDelegateProxy: UInt8 = 0

extension UITextField {

    enum KASReturnAction {
        case next(responder: UIResponder)
        case done(block: (UITextField) -> Void)
    }

    func kas_setReturnAction(_ action: KASReturnAction, delegate: UITextFieldDelegate? = nil) {
        switch action {
        case .next:
            returnKeyType = .next
        case .done:
            returnKeyType = .done
        }

        kas_returnAction = action
        self.delegate = kas_textFieldDelegateProxy
        kas_textFieldDelegateProxy.delegate = delegate
        kas_textFieldDelegateProxy.textField = self
    }

    private var kas_returnAction: KASReturnAction? {
        get {
            if let kas_next = objc_getAssociatedObject(self, &kkas_returnAction) as? KASReturnAction {
                return kas_next
            } else {
                return nil
            }
        }

        set { objc_setAssociatedObject(self, &kkas_returnAction, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var kas_textFieldDelegateProxy: TextFieldDelegateProxy {
        if let kas_textFieldDelegateProxy = objc_getAssociatedObject(self, &kkas_textFieldDelegateProxy) as? TextFieldDelegateProxy {
            return kas_textFieldDelegateProxy
        }

        let proxy = TextFieldDelegateProxy()
        proxy.textField = self
        objc_setAssociatedObject(self, &kkas_textFieldDelegateProxy, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return proxy
    }

    private class TextFieldDelegateProxy: NSObject, UITextFieldDelegate {
        weak var delegate: UITextFieldDelegate?
        weak var textField: UITextField!

        override func forwardingTarget(for aSelector: Selector!) -> Any? {
            if let delegate = self.delegate, delegate.responds(to: aSelector) {
                return delegate
            } else {
                return nil
            }
        }

        override func responds(to aSelector: Selector!) -> Bool {
            if super.responds(to: aSelector) {
                return true
            } else {
                if let delegate = self.delegate {
                    return delegate.responds(to: aSelector)
                } else {
                    return false
                }
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let action = self.textField.kas_returnAction {
                switch action {
                case .next(let responder):
                    responder.becomeFirstResponder()
                case .done(let block):
                    block(self.textField)
                }
            }

            if let delegate = self.delegate, delegate.responds(to: #selector(textFieldShouldReturn(_:))) {
                return delegate.textFieldShouldReturn!(self.textField)
            } else {
                return false
            }
        }
    }
}
