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

class WKWebViewController: UIViewController {
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
        webProgressView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(1)
            make.left.right.equalTo(view)
            make.top.equalTo(view).offset(100)
        }

        view.addSubview(goNextBtn)
        goNextBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.left.equalTo(view).offset(10)
            make.top.equalTo(view).offset(200)
        }
        view.addSubview(goBackBtn)
        goBackBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.right.equalTo(view).offset(-10)
            make.top.equalTo(view).offset(200)
        }
        view.addSubview(reloadBtn)
        reloadBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.right.equalTo(view).offset(-80)
            make.top.equalTo(view).offset(200)
        }

        // setup bridge
        bridge = WKWebViewJSBridge(webView: webView)
        bridge.register(handlerName: "testiOSCallback") { (paramters, callback) in
            print("testiOSCallback called: \(String(describing: paramters))")
            callback?("Response from testiOSCallback")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView.load(URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 100))
    }

    lazy var webProgressView: UIProgressView = {
        let webProgressView = UIProgressView()
        webProgressView.tintColor = .blue
        webProgressView.trackTintColor = .white
        return webProgressView
    }()
    lazy var webView: WKWebView = {
        let webView =  WKWebView(frame: CGRect(), configuration: WKWebViewConfiguration())
        webView.frame = view.bounds
        webView.navigationDelegate = self as WKNavigationDelegate
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        return webView
    }()

    lazy var goNextBtn: UIButton = {
        let goNextBtn = UIButton.init(style: .blue)
        goNextBtn.setTitle("next", for: .normal)
        goNextBtn.addTarget(self, action: #selector(goNextBtnAction), for: .touchUpInside)
        return goNextBtn
    }()
    lazy var goBackBtn: UIButton = {
        let goBackBtn = UIButton.init(style: .blue)
        goBackBtn.setTitle("back", for: .normal)
        goBackBtn.addTarget(self, action: #selector(goBackBtnAction), for: .touchUpInside)
        return goBackBtn
    }()

    lazy var reloadBtn: UIButton = {
        let reloadBtn = UIButton.init(style: .blue)
        reloadBtn.setTitle("reload", for: .normal)
        reloadBtn.addTarget(self, action: #selector(reloadWebView), for: .touchUpInside)
        return reloadBtn
    }()

    @objc func callHandler() {
        let data = ["greetingFromiOS": "Hi there, JS!"]
        bridge.call(handlerName: "testJavascriptHandler", data: data) { (response) in
            print("testJavascriptHandler responded: \(String(describing: response))")
        }

    }

    @objc func goNextBtnAction() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: { (records) in
            for record in records {
                //清除本站的cookie

                    WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                        //清除成功
                        print("清除成功\(record)")
                    })

            }
        })

//        webView.goBack()
    }

    @objc func goBackBtnAction() {
        bridge.call(handlerName: "changeColor", data: ["color": "red"]) {  (response) in
            print("testJavascriptHandler responded: \(String(describing: response))")
        }
    }

    @objc func reloadWebView() {
        webView.reload()
    }
}

extension WKWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webViewDidStartLoad")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webViewDidFinishLoad")
    }
}
extension WKWebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {

        let obj = object as AnyObject?

        if let keyPathValue = keyPath, let changeType = change?[NSKeyValueChangeKey.kindKey],
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
