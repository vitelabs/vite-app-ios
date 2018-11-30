//
//  UIViewControllerExtension.swift
//  Vite
//
//  Created by Stone on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

public enum ViewControllerDataStatus {
    case normal
    case loading
    case empty
    case networkError(Error, () -> Swift.Void)
    case custom(String)
}

public protocol ViewControllerDataStatusable: class {
    var dataStatusView: UIView { get set }
    var dataStatus: ViewControllerDataStatus { get set }
    func emptyView() -> UIView
    func networkErrorView(error: Error, retry: @escaping () -> Swift.Void) -> UIView
    func customView(message: String) -> UIView
}

extension ViewControllerDataStatusable {

    public func emptyView() -> UIView {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "Empty"
        return label
    }

    public func loadingView() -> UIView {
        let view = UIActivityIndicatorView(style: .gray)
        view.startAnimating()
        return view
    }

    public func networkErrorView(error: Error, retry: @escaping () -> Swift.Void) -> UIView {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.red
        button.setTitle(error.message, for: .normal)
        return button
    }

    public func customView(message: String) -> UIView {
        let label = UILabel()
        label.backgroundColor = UIColor.green
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = message
        return label
    }

}

private var kDataStatusViewKey: UInt8 = 0
private var kDataStatusKey: UInt8 = 0

extension ViewControllerDataStatusable where Self: UIViewController {

    public var dataStatusView: UIView {
        get {
            if let dataStatusView = objc_getAssociatedObject(self, &kDataStatusViewKey) as? UIView {
                return dataStatusView
            }
            let dataStatusView = UIView()
            dataStatusView.backgroundColor = UIColor.clear
            dataStatusView.isHidden = true

            if let vc = self as? BaseTableViewController {
                view.insertSubview(dataStatusView, aboveSubview: vc.tableView)
                dataStatusView.backgroundColor = vc.tableView.backgroundColor
            } else {
                view.addSubview(dataStatusView)
                dataStatusView.backgroundColor = view.backgroundColor
            }

            if let vc = self as? BaseViewController, let navigationTitleView = vc.navigationTitleView {
                dataStatusView.snp.makeConstraints({ (m) in
                    m.top.equalTo(navigationTitleView.snp.bottom)
                    m.left.right.bottom.equalTo(view)
                })
            } else {
                dataStatusView.snp.makeConstraints({ (m) in
                    m.edges.equalTo(view)
                })
            }

            objc_setAssociatedObject(self, &kDataStatusViewKey, dataStatusView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return dataStatusView
        }

        set {
            objc_setAssociatedObject(self, &kDataStatusViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var dataStatus: ViewControllerDataStatus {
        get {
            if let status = objc_getAssociatedObject(self, &kDataStatusKey) as? ViewControllerDataStatus {
                return status
            }
            let status = ViewControllerDataStatus.normal
            objc_setAssociatedObject(self, &kDataStatusKey, status, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return status
        }

        set {
            objc_setAssociatedObject(self, &kDataStatusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            dataStatusView.subviews.forEach {
                $0.removeFromSuperview()
            }

            switch newValue {
            case .normal:
                dataStatusView.isHidden = true
            case .loading:
                let view = loadingView()
                dataStatusView.addSubview(view)
                dataStatusView.isHidden = false
                view.snp.makeConstraints({ (m) in
                    m.top.equalTo(dataStatusView.snp.topMargin)
                    m.left.equalTo(dataStatusView.snp.leftMargin)
                    m.right.equalTo(dataStatusView.snp.rightMargin)
                    m.bottom.equalTo(dataStatusView.snp.bottomMargin)
                })
            case .empty:
                let view = emptyView()
                dataStatusView.addSubview(view)
                dataStatusView.isHidden = false
                view.snp.makeConstraints({ (m) in
                    m.top.equalTo(dataStatusView.snp.topMargin)
                    m.left.equalTo(dataStatusView.snp.leftMargin)
                    m.right.equalTo(dataStatusView.snp.rightMargin)
                    m.bottom.equalTo(dataStatusView.snp.bottomMargin)
                })
            case .networkError(let error, let retry):
                let view = networkErrorView(error: error, retry: retry)
                dataStatusView.addSubview(view)
                dataStatusView.isHidden = false
                view.snp.makeConstraints({ (m) in
                    m.top.equalTo(dataStatusView.snp.topMargin)
                    m.left.equalTo(dataStatusView.snp.leftMargin)
                    m.right.equalTo(dataStatusView.snp.rightMargin)
                    m.bottom.equalTo(dataStatusView.snp.bottomMargin)
                })
            case .custom(let message):
                let view = customView(message: message)
                dataStatusView.addSubview(view)
                dataStatusView.isHidden = false
                view.snp.makeConstraints({ (m) in
                    m.top.equalTo(dataStatusView.snp.topMargin)
                    m.left.equalTo(dataStatusView.snp.leftMargin)
                    m.right.equalTo(dataStatusView.snp.rightMargin)
                    m.bottom.equalTo(dataStatusView.snp.bottomMargin)
                })
            }
        }
    }
}
