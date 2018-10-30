//
//  AddAddressFloatView.swift
//  Vite
//
//  Created by Stone on 2018/10/26.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import pop
import RxSwift
import RxCocoa
import NSObject_Rx

protocol AddAddressFloatViewDelegate: class {
    func currentAddressButtonDidClick()
    func scanButtonDidClick()
}

class AddAddressFloatView: VisualEffectAnimationView {

    fileprivate let currentAddressButton = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
        $0.setTitle(R.string.localizable.sendPageAddCurrentAddressButtonTitle.key.localized(), for: .normal)
        $0.setBackgroundImage(R.image.background_address_add_button_white()?.resizable, for: .normal)
        $0.setBackgroundImage(R.image.background_address_add_button_white()?.tintColor(UIColor(netHex: 0xefefef)).resizable, for: .highlighted)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.cornerRadius = 2
    }

    fileprivate let scanButton = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
        $0.setTitle(R.string.localizable.sendPageScanAddressButtonTitle.key.localized(), for: .normal)
        $0.setBackgroundImage(R.image.background_address_add_button_white()?.resizable, for: .normal)
        $0.setBackgroundImage(R.image.background_address_add_button_white()?.tintColor(UIColor(netHex: 0xefefef)).resizable, for: .highlighted)
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 3
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.cornerRadius = 2
    }

    fileprivate let containerView: UIView = UIView()

    fileprivate weak var delegate: AddAddressFloatViewDelegate?
    init(targetView: UIView, delegate: AddAddressFloatViewDelegate) {

        self.delegate = delegate
        guard let superView = targetView.ofViewController?.navigationController?.view else { fatalError() }
        super.init(superview: superView, style: .color(color: UIColor.clear))

        contentView.addSubview(containerView)

        containerView.addSubview(currentAddressButton)
        containerView.addSubview(scanButton)

        containerView.layer.anchorPoint = CGPoint(x: 1, y: 1)
        let layoutGuide = UILayoutGuide()
        contentView.addLayoutGuide(layoutGuide)
        layoutGuide.snp.makeConstraints { (m) in
            m.size.equalTo(containerView).multipliedBy(0.5)
            m.left.equalTo(contentView.safeAreaLayoutGuideSnpRight)
            m.top.equalTo(contentView.safeAreaLayoutGuideSnpBottom)
        }

        guard let targetSuperView = targetView.superview else { fatalError() }
        let frame = targetSuperView.convert(targetView.frame, to: superView)

        containerView.snp.makeConstraints { (m) in
            m.right.equalTo(layoutGuide).offset(frame.maxX - superView.frame.width)
            m.bottom.equalTo(layoutGuide).offset(frame.minY - superView.frame.height)
        }

        currentAddressButton.snp.makeConstraints { (m) in
            m.top.right.equalTo(containerView)
            m.left.greaterThanOrEqualTo(containerView)
        }

        scanButton.snp.makeConstraints { (m) in
            m.top.equalTo(currentAddressButton.snp.bottom).offset(14)
            m.right.equalTo(containerView)
            m.left.greaterThanOrEqualTo(containerView)
            m.bottom.equalTo(containerView).offset(-14)
        }

        currentAddressButton.rx.tap.bind { [weak self] in
            self?.hide()
            self?.delegate?.currentAddressButtonDidClick()
        }.disposed(by: rx.disposeBag)

        scanButton.rx.tap.bind { [weak self] in
            self?.hide(animations: nil, completion: { [weak self] in
                self?.delegate?.scanButtonDidClick()
            })
        }.disposed(by: rx.disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func show(animations: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        super.show(animations: animations, completion: completion)
        let animation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)!
        animation.fromValue = NSValue(cgSize: CGSize(width: 0, height: 0))
        animation.toValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        animation.springBounciness = 10
        containerView.layer.pop_add(animation, forKey: "layerScaleSmallSpringAnimation")
    }

    override func hide(animations: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        super.hide(animations: animations, completion: completion)
        let animation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)!
        animation.fromValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        animation.toValue = NSValue(cgSize: CGSize(width: 0, height: 0))
        animation.springBounciness = 10
        containerView.layer.pop_add(animation, forKey: "layerScaleSmallSpringAnimation")
    }

}
