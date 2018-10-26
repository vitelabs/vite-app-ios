//
//  VisualEffectAnimationView.swift
//  Vite
//
//  Created by Stone on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class VisualEffectAnimationView: UIVisualEffectView {

    enum BackgroundStyle {
        case blurEffect(blurEffect: UIBlurEffect)
        case color(color: UIColor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isEnableTapDismiss: Bool = true
    var animateDuration: TimeInterval = 0.25
    fileprivate let style: BackgroundStyle

    init(superview: UIView, style: BackgroundStyle = .color(color: UIColor.black.withAlphaComponent(0.4))) {
        self.style = style
        super.init(effect: nil)

        contentView.alpha = 0
        switch self.style {
        case .blurEffect:
            break
        case .color(let color):
            contentView.backgroundColor = color
        }

        superview.addSubview(self)
        self.snp.makeConstraints { (m) in m.edges.equalTo(superview) }

        let button = UIButton()
        contentView.addSubview(button)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(tap), for: .touchDown)
        button.snp.makeConstraints { (m) in m.edges.equalTo(contentView) }
    }

    @objc fileprivate func tap() {
        if isEnableTapDismiss {
            hide()
        }
    }

    func show(animations: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: animateDuration, animations: {
            switch self.style {
            case .blurEffect(let blurEffect):
                self.effect = blurEffect
            case .color:
                break
            }
            self.contentView.alpha = 1
            if let a = animations { a() }
        }, completion: { _ in
            if let c = completion { c() }
        })
    }

    func hide(animations: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: animateDuration, animations: {
            self.effect = nil
            self.contentView.alpha = 0
            if let a = animations { a() }
        }, completion: { _ in
            self.removeFromSuperview()
            if let c = completion { c() }
        })
    }
}
