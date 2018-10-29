//
//  GetPowFloatView.swift
//  Vite
//
//  Created by Stone on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import DACircularProgress

class GetPowFloatView: VisualEffectAnimationView {

    fileprivate let containerView: UIView = UIView().then {
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 2
        $0.layer.masksToBounds = true
    }

    fileprivate let titleLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x007AFF)
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.text = R.string.localizable.quotaFloatViewTitle.key.localized()
    }

    fileprivate let progressView = DACircularProgressView().then {
        $0.trackTintColor = UIColor(netHex: 0xefefef)
        $0.progressTintColor = UIColor(netHex: 0x007AFF)
        $0.thicknessRatio = 0.04
        $0.roundedCorners = 1
    }

    fileprivate let progressLabel = UILabel().then {
        $0.textColor = UIColor(netHex: 0x007AFF)
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
    }

    let cancelButton = UIButton().then {
        $0.setTitle(R.string.localizable.cancel.key.localized(), for: .normal)
        $0.setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
        $0.setTitleColor(UIColor(netHex: 0x007AFF).highlighted, for: .highlighted)
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(netHex: 0x007AFF).cgColor
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
    }

    init(superview: UIView) {
        super.init(superview: superview)

        isEnableTapDismiss = false

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(progressView)
        containerView.addSubview(progressLabel)
        containerView.addSubview(cancelButton)

        containerView.snp.makeConstraints { (m) in
            m.center.equalTo(contentView)
            m.size.equalTo(CGSize(width: 240, height: 250))
        }

        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(containerView).offset(18)
            m.centerX.equalTo(containerView)
        }

        progressView.snp.makeConstraints { (m) in
            m.top.equalTo(titleLabel.snp.bottom).offset(18)
            m.centerX.equalTo(containerView)
            m.size.equalTo(CGSize(width: 112, height: 112))
        }

        progressLabel.snp.makeConstraints { (m) in
            m.center.equalTo(progressView)
        }

        cancelButton.snp.makeConstraints { (m) in
            m.bottom.equalTo(containerView).offset(-15)
            m.centerX.equalTo(containerView)
            m.height.equalTo(40)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var progress = 0
    override func show(animations: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        super.show(animations: animations, completion: completion)
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).bind { [weak self] _ in
            guard let `self` = self else { return }
            self.progress = min(self.progress + 1, 99)
            self.updateProgress()
        }.disposed(by: rx.disposeBag)
    }

    override func hide(animations: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        super.hide(animations: animations, completion: completion)
        removeFromSuperview()
    }

    func updateProgress(_ animated: Bool = true) {
        self.progressLabel.text = String(self.progress) + "%"
        self.progressView.setProgress(CGFloat(self.progress) / 100.0, animated: animated)
    }

    func finish(completion: @escaping () -> Void) {
        self.cancelButton.isUserInteractionEnabled = false
        self.progress = 100
        updateProgress(false)
        GCD.delay(0.25) { self.hide(animations: nil, completion: completion) }
    }
}
