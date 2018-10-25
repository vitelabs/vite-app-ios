//
//  WKWebViewJavascriptBridgeEngine.swift
//  Vite
//
//  Created by Water on 2018/10/22.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

protocol WKWebViewJSBridgeEngineDelegate: AnyObject {
    func evaluateJavascript(javascript: String)
}

@available(iOS 9.0, *)
public class WKWebViewJSBridgeEngine: NSObject {
    public typealias Callback = (_ responseData: Any?) -> Void
    public typealias Handler = (_ parameters: [String: Any]?, _ callback: Callback?) -> Void
    public typealias Message = [String: Any]

    weak var delegate: WKWebViewJSBridgeEngineDelegate?
    var startupMessageQueue = [Message]()
    var responseCallbacks = [String: Callback]()
    var messageHandlers = [String: Handler]()
    var uniqueId = 0

    func reset() {
        startupMessageQueue = [Message]()
        responseCallbacks = [String: Callback]()
        uniqueId = 0
    }

    func send(handlerName: String, data: Any?, callback: Callback?) {
        var message = [String: Any]()
        message["handlerName"] = handlerName

        if data != nil {
            message["data"] = data
        }

        if callback != nil {
            uniqueId += 1
            let callbackID = "native_iOS_cb_\(uniqueId)"
            responseCallbacks[callbackID] = callback
            message["callbackID"] = callbackID
        }

        queue(message: message)
    }

    func sendResponds(_ message: Message) {
        self.queue(message: message)
    }

    func flush(messageQueueString: String) {
        guard let messages = deserialize(messageJSON: messageQueueString) else {
            plog(level: .debug, log: messageQueueString, tag: .web)
            return
        }

        for message in messages {
            plog(level: .debug, log: message, tag: .web)

            if let responseID = message["responseID"] as? String {
                guard let callback = responseCallbacks[responseID] else { continue }
                callback(message["responseData"])
                responseCallbacks.removeValue(forKey: responseID)
            } else {
                var  callback: Callback?
                if let callbackID = message["callbackID"] {
                    callback = { (_ responseData: Any?) -> Void in
                        let msg = ["responseID": callbackID, "responseData": responseData ?? NSNull()] as Message
                        self.queue(message: msg)
                    }
                } else {
                    callback = { (_ responseData: Any?) -> Void in
                        // no logic
                    }
                    return
                }

                guard let handlerName = message["handlerName"] as? String else { return }

                let aSel: Selector = NSSelectorFromString("jsapi_" + handlerName+("WithParameters:callbackID:"))//
                let isResponds = self.responds(to: aSel)
                if isResponds {
                    self.perform(aSel, with: message["data"] as? [String: Any], with: message["callbackID"])
                } else {
                    guard let handler = messageHandlers[handlerName] else {
                        plog(level: .debug, log: "NoHandlerException, No handler for message from JS: \(message)", tag: .web)
                        return
                    }
                    handler(message["data"] as? [String: Any], callback)
                }
            }
        }
    }

    func injectJavascriptFile() {
        let js = InjectJSBridgeJS
        delegate?.evaluateJavascript(javascript: js)
    }

    // MARK: - Private
    private func queue(message: Message) {
        if startupMessageQueue.isEmpty {
            dispatch(message: message)
        } else {
            startupMessageQueue.append(message)
        }
    }

    // MARK: - Private
    private func dispatch(message: Message) {
        guard var messageJSON = serialize(message: message, pretty: false) else { return }

        messageJSON = messageJSON.replacingOccurrences(of: "\\", with: "\\\\")
        messageJSON = messageJSON.replacingOccurrences(of: "\"", with: "\\\"")
        messageJSON = messageJSON.replacingOccurrences(of: "\'", with: "\\\'")
        messageJSON = messageJSON.replacingOccurrences(of: "\n", with: "\\n")
        messageJSON = messageJSON.replacingOccurrences(of: "\r", with: "\\r")
        messageJSON = messageJSON.replacingOccurrences(of: "\u{000C}", with: "\\f")
        messageJSON = messageJSON.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
        messageJSON = messageJSON.replacingOccurrences(of: "\u{2029}", with: "\\u2029")

        let javascriptCommand = "WKWebViewJavascriptBridge._handleMessageFromiOS('\(messageJSON)');"
        if Thread.current.isMainThread {
            delegate?.evaluateJavascript(javascript: javascriptCommand)
        } else {
            DispatchQueue.main.async {
                self.delegate?.evaluateJavascript(javascript: javascriptCommand)
            }
        }
    }

    // MARK: - JSON
    private func serialize(message: Message, pretty: Bool) -> String? {
        var result: String?
        do {
            let data = try JSONSerialization.data(withJSONObject: message, options: pretty ? .prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0))
            result = String(data: data, encoding: .utf8)
        } catch let error {
            plog(level: .debug, log: error, tag: .web)
        }
        return result
    }

  private func deserialize(messageJSON: String) -> [Message]? {
        var result = [Message]()
        guard let data = messageJSON.data(using: .utf8) else { return nil }
        do {
            result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [WKWebViewJSBridgeEngine.Message]
        } catch let error {
            plog(level: .debug, log: error, tag: .web)
        }
        return result
    }
}
