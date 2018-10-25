//
//  WKWebViewController.swift
//  Vite
//
//  Created by Water on 2018/10/22.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class WKWebViewController: UIViewController, WKNavigationDelegate {
    private var bridge: WKWebViewJSBridge!
    private var url: URL!

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(webView)
        view.addSubview(webProgressView)
        view.addSubview(webToolBarView)

        webProgressView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(2)
            make.left.right.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuideSnpTop)
        }

        webToolBarView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuideSnpBottom)
        }

        // setup bridge
        bridge = WKWebViewJSBridge(webView: webView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView.load(URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 100))
    }

    lazy var webProgressView: UIProgressView = {
        let webProgressView = UIProgressView()
        webProgressView.sizeToFit()
        webProgressView.tintColor = .blue
        webProgressView.trackTintColor = .white
        return webProgressView
    }()
    lazy var webView: WKWebView = {
        let webView =  WKWebView(frame: CGRect(), configuration: WKWebViewConfiguration())
        webView.frame = view.bounds
        webView.navigationDelegate = self as WKNavigationDelegate
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: NSKeyValueObservingOptions.new, context: nil)
        return webView
    }()

    lazy var webToolBarView: WebToolBarView = {
        let webToolBarView =  WebToolBarView()
        webToolBarView.reloadBtn.addTarget(self, action: #selector(reloadWebView), for: .touchUpInside)
        webToolBarView.goBackBtn.addTarget(self, action: #selector(goBackBtnAction), for: .touchUpInside)
        webToolBarView.goNextBtn.addTarget(self, action: #selector(goNextBtnAction), for: .touchUpInside)
        return webToolBarView
    }()

    @objc func goNextBtnAction() {
        webView.goForward()
    }
    @objc func goBackBtnAction() {
        webView.goBack()
    }
    @objc func reloadWebView() {
        webView.reload()
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        plog(level: .debug, log: "webViewDidStartLoad: \(String(describing: webView.url?.absoluteString))", tag: .web)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        plog(level: .debug, log: "webViewDidFinishLoad: \(String(describing: webView.url?.absoluteString))", tag: .web)
    }
}
extension WKWebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let keyPathValue = keyPath, let _ = change?[NSKeyValueChangeKey.kindKey],
            ((keyPathValue == "estimatedProgress") ) {//obj === self &&
            let newProgress = change?[NSKeyValueChangeKey.newKey] as! NSNumber
            self.webProgressView.alpha = 1.0
            self.webProgressView.setProgress(newProgress.floatValue, animated: true)

            if newProgress.floatValue >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 1.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.webProgressView.alpha = 0.0
                }, completion: {_ in
                    self.webProgressView.setProgress(0, animated: false)
                })
            }
        }
    }
}
