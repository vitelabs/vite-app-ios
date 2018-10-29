//
//  StyleActionSheetTranstion.swift
//  Vite
//
//  Created by Water on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

protocol QCSPresentParentAnimationProtocal {

    func presentAnimation()

    func appearAnimation()

    func showSheetMaskView()
}

enum  StyleActionSheetTranstionDelegateType {
    case present
    case dismiss
}

class StyleActionSheetAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    let type: StyleActionSheetTranstionDelegateType
    let backgroundView: UIView
    init(type: StyleActionSheetTranstionDelegateType, backgroundView: UIView) {
        self.type = type
        self.backgroundView = backgroundView
    }

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let fromView = fromVC.view else { return }
        guard let toView = toVC.view else { return }

        let containerView = transitionContext.containerView
        let duration = self.transitionDuration(using: transitionContext)
        let finalFrame = transitionContext.initialFrame(for: fromVC)

        if self.type ==  .present {
            toView.frame = CGRect(x: 0, y: kScreenH, width: finalFrame.size.width, height: finalFrame.size.height)
            self.backgroundView.frame = containerView.convert(CGRect(x: 0, y: 0, width: fromView.frame.size.width, height: fromView.frame.size.height), to: fromView)
            self.backgroundView.alpha = 0
            containerView.addSubview(self.backgroundView)

            containerView.addSubview(toView)
            UIView.animate(withDuration: duration/2.0) {
                self.backgroundView.alpha = 0.4
                toView.frame = finalFrame
            }

            let backgroundColor = toView.backgroundColor
            toView.backgroundColor = toView.backgroundColor?.withAlphaComponent(0)

            UIView.animate(withDuration: duration, animations: {
                toView.backgroundColor = backgroundColor
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else if self.type ==  .dismiss {
            toView.frame = finalFrame
            UIView.animate(withDuration: duration/2.0, animations: {
                fromView.frame = CGRect(x: 0, y: kScreenH, width: finalFrame.size.width, height: finalFrame.size.height)
                self.backgroundView.alpha = 0
            }, completion: { _ in
                self.backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
}

class StyleActionSheetTranstionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return StyleActionSheetAnimatedTransitioning(type: .present, backgroundView: self.backgroundView)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
           return StyleActionSheetAnimatedTransitioning(type: .dismiss, backgroundView: self.backgroundView)
    }
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(netHex: 0x1A1A1A)
        backgroundView.autoresizingMask =  .flexibleWidth
        return backgroundView
    }()
}
