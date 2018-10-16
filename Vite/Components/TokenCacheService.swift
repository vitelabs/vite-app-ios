//
//  TokenCacheService.swift
//  Vite
//
//  Created by Stone on 2018/9/16.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Alamofire

class TokenCacheService {
    static let instance = TokenCacheService()
    fileprivate let fileHelper = FileHelper(.library, appending: FileHelper.appPathComponent)
    fileprivate static let saveKey = "TokenCache"

    var viteToken: Token {
        return defaultTokens[0]
    }

    let defaultTokens: [Token] = [Token(id: Token.Currency.vite.rawValue, name: "vite", symbol: "VITE", decimals: 18),
                                  Token(id: Token.Currency.vcp.rawValue, name: "Vite Community Point", symbol: "VCP", decimals: 0),
                                  Token(id: Token.Currency.vv.rawValue, name: "Vite Voucher", symbol: "VV", decimals: 18),
                                  ]
    var tokenDic = [String: Token]()

    private init() {
        if let data = self.fileHelper.contentsAtRelativePath(type(of: self).saveKey),
            let jsonString = String(data: data, encoding: .utf8),
            let tokens = [Token](JSONString: jsonString) {
            for token in tokens {
                tokenDic[token.id] = token
            }
        } else {
            for token in defaultTokens {
                tokenDic[token.id] = token
            }
        }
    }

    func updateTokensIfNeeded(_ tokens: [Token]) {
        var neededSave = false

        for token in tokens where tokenDic[token.id] == nil {
            tokenDic[token.id] = token
            neededSave = true
        }

        if neededSave {
            if let data = tokenDic.map({ (_, value) -> Token in return value }).toJSONString()?.data(using: .utf8) {
                do {
                    try fileHelper.writeData(data, relativePath: type(of: self).saveKey)
                } catch let error {
                    assert(false, error.localizedDescription)
                }
            }
        }
    }
}

extension TokenCacheService {

    func tokenForId(_ id: String, completion: @escaping (Alamofire.Result<Token>) -> Void) {

        if let token = tokenForId(id) {
            completion(Result.success(token))
        } else {
            Provider.instance.getTokenForId(id) { result in
                switch result {
                case .success(let token):
                    TokenCacheService.instance.updateTokensIfNeeded([token])
                    completion(Result.success(token))
                case .error(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }

    func tokenForId(_ id: String) -> Token? {
        return tokenDic[id]
    }

    func iconForId(_ id: String) -> Token.Icon {
        if let _ = Token.Currency(rawValue: id) {
            return Token.Icon.image(image: R.image.icon_token_vite_white()!)
        } else {
            return Token.Icon.image(image: R.image.icon_token_vite_white()!)
        }
    }

    func backgroundColorsForId(_ id: String) -> [UIColor] {
        if let type = Token.Currency(rawValue: id) {
            switch type {
            case .vite:
                return [UIColor(netHex: 0x0C3EE6),
                        UIColor(netHex: 0x00C3FF),
                ]
            case .vcp:
                return [ UIColor(netHex: 0xF76B1C),
                         UIColor(netHex: 0xFAD961),
                ]
            case .vv:
                return [UIColor(netHex: 0x429321),
                        UIColor(netHex: 0xB4EC51),
                ]
            }
        } else {
            return [UIColor(netHex: 0xf0f0f0)]
        }
    }
}

extension Token {

    enum Currency: String {
        case vite = "tti_5649544520544f4b454e6e40"
        case vcp = "tti_12ea0c02170304090a5ac879"
        case vv = "tti_b6187a150d175e5a165b1c5b"
    }

    enum Icon {
        case url(url: URL)
        case image(image: UIImage)

        func putIn(_ imageView: UIImageView) {
            switch self {
            case .image(let image):
                imageView.image = image
            case .url(let url):
                fatalError("\(url) Currently not supported!")
            }
        }
    }
}
