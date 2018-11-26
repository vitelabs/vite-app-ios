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
import RxSwift
import RxCocoa
import NSObject_Rx

class TokenCacheService: NSObject, Mappable {
    static let instance = TokenCacheService()
    fileprivate let fileHelper = FileHelper(.library, appending: FileHelper.appPathComponent)
    fileprivate static let saveKey = "TokenCache"

    static fileprivate let viteTokenId = "tti_5649544520544f4b454e6e40"
    static fileprivate let viteTokenName = "vite"
    static fileprivate let viteTokenSymbol = "VITE"
    static fileprivate let viteTokenDecimals = 18
    static fileprivate let viteTokenColors = ["0x0C3EE6", "0x00C3FF"]

    static fileprivate let otherTokenKey = "other"
    static fileprivate let otherTokenColors = ["0x24283E", "0x485173", "0x485173"]

    var defaultTokens: [Token] = [Token(id: viteTokenId, name: viteTokenName, symbol: viteTokenSymbol, decimals: viteTokenDecimals)]
    fileprivate var colorDic = [viteTokenId: viteTokenColors, otherTokenKey: otherTokenColors]
    fileprivate var tokenDic = [String: Token]()

    private override init() {

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
        tokenDic <- map["tokenDic"]
    }

    func start() {
        AppSettingsService.instance.configDriver.asObservable().bind { [weak self] (config) in
            guard let `self` = self else { return }
            guard let array = config.defaultTokens["defaults"] as? [[String: Any]],
                let other = config.defaultTokens["other"] as? [String: Any],
                let colors = other["colors"] as? [String] else { return }

            let tokens = [Token](JSONArray: array).compactMap { $0 }
            guard !tokens.isEmpty else { return }
            guard !colors.isEmpty else { return }

            self.defaultTokens = tokens
            self.colorDic[type(of: self).otherTokenKey] = colors

            for dic in array {
                if let id = dic["tokenId"] as? String,
                    let colors = dic["colors"] as? [String] {
                    self.colorDic[id] = colors
                }
            }
        }.disposed(by: rx.disposeBag)
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

    fileprivate func pri_save() {
        if let data = self.toJSONString()?.data(using: .utf8) {
            if let error = fileHelper.writeData(data, relativePath: type(of: self).saveKey) {
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
                case .failure(let error):
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

    func iconForId(_ id: String) -> ImageWrapper {
        return ImageWrapper.image(image: R.image.icon_token_vite_white()!)
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

#if DEBUG || TEST
extension TokenCacheService {
    func deleteCache() {
        if let error = fileHelper.deleteFileAtRelativePath(type(of: self).saveKey) {
            assert(false, error.localizedDescription)
        }
    }
}
#endif
