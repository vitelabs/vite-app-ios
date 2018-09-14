//
//  UIViewController+KeyboardAutoScrolling.swift
//  Vite
//
//  Created by Stone on 2018/9/13.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

final class KeyboardAutoScrollingObserver {

    weak var viewController: UIViewController?
    var targetView: UIView?
    var keyboardTapGestureRecognizer: UITapGestureRecognizer?
    var hasScrollView: Bool!
    var contentInset: UIEdgeInsets!
    var scrollIndicatorInsets: UIEdgeInsets!
    var frame: CGRect!

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        print("\(#file) \(#function)")
    }

    func set(viewController: UIViewController, targetView: UIView) {
        if let _ = self.targetView {
            return
        }

        self.viewController = viewController
        self.targetView = targetView

        if let scrollView = self.targetView as? UIScrollView {
            contentInset = scrollView.contentInset
            scrollIndicatorInsets = scrollView.scrollIndicatorInsets
            hasScrollView = true
        } else {
            frame = targetView.frame
            hasScrollView = false
        }
    }

    @objc func keyboardWillShowNotification(notification: Notification) {
        guard let targetView = targetView else { return }
        guard let viewController = viewController else { return }
        guard let firstResponderView = findViewThatIsFirstResponderForView(targetView) else { return }

        if viewController.tapToHideKeyboard {
            if let keyboardTapGestureRecognizer = keyboardTapGestureRecognizer {
                targetView.removeGestureRecognizer(keyboardTapGestureRecognizer)
            }

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTao(recognizer:)))
            tapGesture.cancelsTouchesInView = false
            targetView.addGestureRecognizer(tapGesture)
            self.keyboardTapGestureRecognizer = tapGesture
        }

        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var rect = CGRect.zero

        if let scrollView = self.targetView as? UIScrollView {
            rect = firstResponderView.convert(firstResponderView.bounds, to: targetView)
            rect.size.height += viewController.bottomInset

            let contentInset = UIEdgeInsets(top: self.contentInset.top, left: self.contentInset.left, bottom: max(keyboardSize.height, self.contentInset.bottom), right: self.contentInset.right)
            let scrollIndicatorInsets = UIEdgeInsets(top: self.scrollIndicatorInsets.top, left: self.scrollIndicatorInsets.left, bottom: max(keyboardSize.height, self.scrollIndicatorInsets.bottom), right: self.scrollIndicatorInsets.right)

            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = scrollIndicatorInsets

            UIView.animate(withDuration: 0.25) {
                scrollView.scrollRectToVisible(rect, animated: false)
            }
        } else {
            rect = firstResponderView.convert(firstResponderView.bounds, to: UIApplication.shared.keyWindow)
            rect.size.height += viewController.bottomInset

            let dy = rect.maxY - ( UIScreen.main.bounds.height - keyboardSize.height )

            if dy > 0 {
                UIView.animate(withDuration: 0.25) {
                    targetView.frame = targetView.frame.insetBy(dx: 0, dy: -dy)
                }
            }
        }
    }

    @objc func keyboardWillHideNotification(notification: Notification) {
        guard let targetView = targetView else { return }

        if let keyboardTapGestureRecognizer = keyboardTapGestureRecognizer {
            targetView.removeGestureRecognizer(keyboardTapGestureRecognizer)
            self.keyboardTapGestureRecognizer = nil
        }

        if let scrollView = self.targetView as? UIScrollView {
            UIView.animate(withDuration: 0.25) {
                scrollView.contentInset = self.contentInset
                scrollView.scrollIndicatorInsets = self.scrollIndicatorInsets
            }
        } else {
            if targetView.frame != self.frame {
                UIView.animate(withDuration: 0.25) {
                    targetView.frame = self.frame
                }
            }
        }
    }

    @objc func onTao(recognizer: UIGestureRecognizer) {
        guard let targetView = targetView else { return }

        if recognizer.state == UIGestureRecognizerState.ended {
            guard let view = findViewThatIsFirstResponderForView(targetView) else { return }
            view.resignFirstResponder()
        }
    }

    func findViewThatIsFirstResponderForView(_ view: UIView) -> UIView? {
        if view.isFirstResponder {
            return view
        }

        for subView in view.subviews {
            if let firstResponder = findViewThatIsFirstResponderForView(subView) {
                return firstResponder
            }
        }

        return nil
    }
}

private var kTapToHideKeyboard: UInt8 = 0
private var kBottomInset: UInt8 = 0
private var kObserver: UInt8 = 0

extension UIViewController {

    func kas_activateAutoScrollingForView(_ view: UIView) {
        self.keyboardAutoScrollingObserver.set(viewController: self, targetView: view)
    }

    fileprivate var tapToHideKeyboard: Bool {
        get {
            if let tapToHideKeyboard = objc_getAssociatedObject(self, &kTapToHideKeyboard) as? Bool {
                return tapToHideKeyboard
            } else {
                return true
            }
        }
        set { objc_setAssociatedObject(self, &kTapToHideKeyboard, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    fileprivate var bottomInset: CGFloat {
        get {
            if let bottomInset = objc_getAssociatedObject(self, &kBottomInset) as? CGFloat {
                return bottomInset
            } else {
                return 15.0
            }
        }
        set { objc_setAssociatedObject(self, &kBottomInset, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    fileprivate var keyboardAutoScrollingObserver: KeyboardAutoScrollingObserver {
        if let observer = objc_getAssociatedObject(self, &kObserver) as? KeyboardAutoScrollingObserver {
            return observer
        } else {
            let observer = KeyboardAutoScrollingObserver()
            objc_setAssociatedObject(self, &kObserver, observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return observer
        }
    }
}
