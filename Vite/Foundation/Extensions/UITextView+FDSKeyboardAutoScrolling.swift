//
//  UITextView+FDSKeyboardAutoScrolling.swift
//  Vite
//
//  Created by Stone on 2018/9/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

private var kkas_returnAction: UInt8 = 0
private var kkas_textViewDelegateProxy: UInt8 = 0

extension UITextView {

    enum KASReturnAction {
        case next(responder: UIResponder)
        case done(block: (UITextView) -> Void)
    }

    func kas_setReturnAction(_ action: KASReturnAction, delegate: UITextViewDelegate? = nil) {
        switch action {
        case .next:
            returnKeyType = .next
        case .done:
            returnKeyType = .done
        }

        kas_returnAction = action
        self.delegate = kas_textViewDelegateProxy
        kas_textViewDelegateProxy.delegate = delegate
        kas_textViewDelegateProxy.textView = self
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

    private var kas_textViewDelegateProxy: TextViewDelegateProxy {
        if let kas_textViewDelegateProxy = objc_getAssociatedObject(self, &kkas_textViewDelegateProxy) as? TextViewDelegateProxy {
            return kas_textViewDelegateProxy
        }

        let proxy = TextViewDelegateProxy()
        proxy.textView = self
        objc_setAssociatedObject(self, &kkas_textViewDelegateProxy, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return proxy
    }

    private class TextViewDelegateProxy: NSObject, UITextViewDelegate {
        weak var delegate: UITextViewDelegate?
        weak var textView: UITextView!

        override func forwardingTarget(for aSelector: Selector!) -> Any? {
            if self.responds(to: aSelector) {
                return self
            } else if let delegate = self.delegate, delegate.responds(to: aSelector) {
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

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

            if text == "\n", let action = self.textView.kas_returnAction {
                switch action {
                case .next(let responder):
                    responder.becomeFirstResponder()
                case .done(let block):
                    block(self.textView)
                }

                return false
            } else {
                if let delegate = self.delegate, delegate.responds(to: #selector(textView(_:shouldChangeTextIn:replacementText:))) {
                    return delegate.textView!(self.textView, shouldChangeTextIn: range, replacementText: text)
                } else {
                    return true
                }
            }
        }
    }
}
