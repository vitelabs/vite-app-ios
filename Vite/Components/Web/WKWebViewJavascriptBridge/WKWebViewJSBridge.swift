//
//  WKWebViewJavascriptBridge.swift
//  Vite
//
//  Created by Water on 2018/10/22.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import WebKit

@available(iOS 9.0, *)
public class WKWebViewJSBridge: NSObject {
    private let iOS_Native_InjectJavascript = "iOS_Native_InjectJavascript"
    private let iOS_Native_FlushMessageQueue = "iOS_Native_FlushMessageQueue"

    private weak var webView: WKWebView?
    private var base: WKWebViewJSBridgeEngine!
    private var publish: WKWebViewJSBridgePublish!

    public init(webView: WKWebView) {
        super.init()
        self.webView = webView
        base = WKWebViewJSBridgeEngine()
        base.delegate = self
        publish = WKWebViewJSBridgePublish.init(bridge: self)
        addScriptMessageHandlers()
    }

    deinit {
        removeScriptMessageHandlers()
    }

    // MARK: - Public Funcs
    public func reset() {
        base.reset()
    }

    public func register(handlerName: String, handler: @escaping WKWebViewJSBridgeEngine.Handler) {
        base.messageHandlers[handlerName] = handler
    }

    public func remove(handlerName: String) -> WKWebViewJSBridgeEngine.Handler? {
        return base.messageHandlers.removeValue(forKey: handlerName)
    }

    public func call(handlerName: String, data: Any? = nil, callback: WKWebViewJSBridgeEngine.Callback? = nil) {
        base.send(handlerName: handlerName, data: data, callback: callback)
    }

    // MARK: - Private Funcs
    private func flushMessageQueue() {
        webView?.evaluateJavaScript("WKWebViewJavascriptBridge._fetchQueue();") { (result, error) in
            if error != nil {
                print("WKWebViewJavascriptBridge: WARNING: Error when trying to fetch data from WKWebView: \(String(describing: error))")
            }

            guard let resultStr = result as? String else { return }
            self.base.flush(messageQueueString: resultStr)
        }
    }

    private func addScriptMessageHandlers() {
        webView?.configuration.userContentController.add(LeakAvoider(delegate: self), name: iOS_Native_InjectJavascript)
        webView?.configuration.userContentController.add(LeakAvoider(delegate: self), name: iOS_Native_FlushMessageQueue)
    }

    private func removeScriptMessageHandlers() {
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: iOS_Native_InjectJavascript)
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: iOS_Native_FlushMessageQueue)
    }
}

extension WKWebViewJSBridge: WKWebViewJSBridgeEngineDelegate {
    func evaluateJavascript(javascript: String) {
        webView?.evaluateJavaScript(javascript, completionHandler: nil)
    }
}

extension WKWebViewJSBridge: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == iOS_Native_InjectJavascript {
            base.injectJavascriptFile()
        }

        if message.name == iOS_Native_FlushMessageQueue {
            flushMessageQueue()
        }
    }
}

class LeakAvoider: NSObject {
    weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        super.init()
        self.delegate = delegate
    }
}

extension LeakAvoider: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}
