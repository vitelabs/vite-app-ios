//
//  TokenCacheService.swift
//  Vite
//
//  Created by Stone on 2018/9/16.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import Moya
import SwiftyJSON

class TokenCacheService: Mappable {
    static let instance = TokenCacheService()
    fileprivate let fileHelper = FileHelper(.library, appending: FileHelper.appPathComponent)
    fileprivate static let saveKey = "TokenCache"

    static fileprivate let viteTokenId = "tti_5649544520544f4b454e6e40"
    static fileprivate let viteTokenName = "vite"
    static fileprivate let viteTokenSymbol = "VITE"
    static fileprivate let viteTokenDecimals = 18
    static fileprivate let viteTokenColors = ["0x0C3EE6", "0x00C3FF"]

    static fileprivate let otherTokenKey = "other"
    static fileprivate let otherTokenColors = ["0x24283E", "0x485173"]

    var defaultTokens: [Token] = [Token(id: viteTokenId, name: viteTokenName, symbol: viteTokenSymbol, decimals: viteTokenDecimals)]
    fileprivate var colorDic = [viteTokenId: viteTokenColors, otherTokenKey: otherTokenColors]
    fileprivate var tokenDic = [String: Token]()

    private init() {

        if let data = self.fileHelper.contentsAtRelativePath(type(of: self).saveKey),
            let jsonString = String(data: data, encoding: .utf8),
            let cache = TokenCacheService(JSONString: jsonString) {
            self.defaultTokens = cache.defaultTokens
            self.colorDic = cache.colorDic
            self.tokenDic = cache.tokenDic
        }
    }

    required init?(map: Map) {}

    func mapping(map: Map) {
        defaultTokens <- map["defaultTokens"]
        colorDic <- map["colorDic"]
        tokenDic <- map["tokenDic"]
    }

    func start() {
        pri_updateDefaultTokens()
    }

    func updateTokensIfNeeded(_ tokens: [Token]) {
        var neededSave = false

        for token in tokens where tokenDic[token.id] == nil {
            tokenDic[token.id] = token
            neededSave = true
        }

        if neededSave {
            pri_save()
        }
    }
}

extension TokenCacheService {

    fileprivate func pri_updateDefaultTokens() {

        let manager = Manager(configuration: URLSessionConfiguration.default,
                              serverTrustPolicyManager: ServerTrustPolicyManager(policies: [:]))
        let provider =  MoyaProvider<ViteAPI>(manager: manager)
        let viteAppServiceRequest = ViteAppServiceRequest(provider: provider)
        viteAppServiceRequest.getDefaultTokens()
            .done { [weak self] string in
                guard let `self` = self else { return }
                let json = JSON(parseJSON: string)
                let array = json["defaults"].arrayValue

                self.defaultTokens = array.map { $0.dictionaryObject }.compactMap { $0 }.map { Token(JSON: $0) }.compactMap { $0 }
                for tokenJson in array {
                    if let dic = tokenJson.dictionaryObject,
                        let id = dic["tokenId"] as? String,
                        let colors = dic["colors"] as? [String] {
                        self.colorDic[id] = colors
                    }
                }
                self.pri_save()
                plog(level: .debug, log: "update default tokens finished")
            }.catch({ [weak self] (error) in
                guard let `self` = self else { return }
                plog(level: .warning, log: error.localizedDescription)
                GCD.delay(2, task: {
                    self.pri_updateDefaultTokens()
                })
            })
    }

    fileprivate func pri_save() {
        if let data = self.toJSONString()?.data(using: .utf8) {
            do {
                try fileHelper.writeData(data, relativePath: type(of: self).saveKey)
            } catch let error {
                assert(false, error.localizedDescription)
            }
        }
    }
}

extension TokenCacheService {

    var viteToken: Token { return defaultTokens[0] }

    func tokenForId(_ id: String, completion: @escaping (Alamofire.Result<Token?>) -> Void) {

        if let token = tokenForId(id) {
            completion(Result.success(token))
        } else {
            Provider.instance.getTokenForId(id) { result in
                switch result {
                case .success(let token):
                    if let t = token {
                        TokenCacheService.instance.updateTokensIfNeeded([t])
                    }
                    completion(Result.success(token))
                case .error(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }

    func tokenForId(_ id: String) -> Token? {

        for token in defaultTokens where token.id == id {
            return token
        }

        return tokenDic[id]
    }

    func iconForId(_ id: String) -> Token.Icon {
        return Token.Icon.image(image: R.image.icon_token_vite_white()!)
    }

    func backgroundColorsForId(_ id: String) -> [UIColor] {

        if let colors = colorDic[id] {
            return colors.map { UIColor(hex: $0) }
        } else if let colors = colorDic[type(of: self).otherTokenKey] {
            return colors.map { UIColor(hex: $0) }
        } else {
            return type(of: self).otherTokenColors.map { UIColor(hex: $0) }
        }
    }
}

#if DEBUG
extension TokenCacheService {
    func deleteCache() {
        do {
            try fileHelper.deleteFileAtRelativePath(type(of: self).saveKey)
        } catch let error {
            assert(false, error.localizedDescription)
        }
    }
}
#endif

extension Token {

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
