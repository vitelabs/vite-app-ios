//
//  PopViewController.swift
//  Vite
//
//  Created by Water on 2018/10/29.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NSObject_Rx
import WebKit

class PopViewController: BaseViewController {
    let url: URL
    weak var delegate: QuotaSubmitPopViewControllerDelegate?

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        initBinds()
        self.webView.load(URLRequest.init(url: self.url))
    }

    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
    }

    lazy var bgView = UIView().then {
        $0.backgroundColor = .white
        $0.setupShadow(CGSize(width: 0, height: 5))
    }

    lazy var webView = WKWebView().then {
        $0.backgroundColor = .white
        $0.navigationDelegate = self
        $0.scrollView.bounces = true
        $0.scrollView.alwaysBounceVertical = true
        $0.scrollView.showsHorizontalScrollIndicator = false
    }

    lazy var cancelBtn = UIButton(style: .white, title: R.string.localizable.close.key.localized())

    func setupView() {
        self.navigationController?.view.backgroundColor = .clear
        self.view.backgroundColor = .clear

        view.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
            make.left.equalTo(view).offset(52)
            make.right.equalTo(view).offset(-52)
            make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuideSnpTop).offset(80)
            make.bottom.greaterThanOrEqualTo(view.safeAreaLayoutGuideSnpBottom).offset(-80)
        }

        bgView.addSubview(webView)
        webView.snp.makeConstraints { (m) in
            m.left.right.equalTo(bgView)
            m.top.equalTo(bgView)
            m.height.lessThanOrEqualTo(1000)
        }

        bgView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (m) in
            m.left.right.equalTo(bgView)
            m.top.equalTo(webView.snp.bottom).offset(15)
            m.bottom.equalTo(bgView)
            m.height.equalTo(50)
        }

        let lineView = LineView.init(direction: .horizontal)
        cancelBtn.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(cancelBtn)
            make.height.equalTo(1)
        }
    }

    func initBinds() {
        self.cancelBtn.rx.tap
            .bind { [weak self] in
                self?.dismiss()
            }.disposed(by: rx.disposeBag)
    }
}

extension PopViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        _ = self.webView.evaluateJavaScript("document.body.scrollHeight") { (result, _) in
            let num = result as! NSNumber
            let webViewHeight =  num.floatValue
            webView.snp.updateConstraints { (m) in
                m.height.lessThanOrEqualTo(webViewHeight)
            }
        }

    }
}
