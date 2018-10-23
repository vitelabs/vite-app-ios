//
//  ScanViewReactor.swift
//  Vite
//
//  Created by haoshenyang on 2018/10/17.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift
import AVFoundation
import Alamofire

final class ScanViewReactor: Reactor {

    enum Action {
        case scanQRCode(AVMetadataObject?)
        case pickeImage(UIImage?)
    }

    enum Mutation {
        case processAVMetadata(AVMetadataObject?)
        case processImage(UIImage?)
        case creatURI
        case setLoading(Bool)
        case confirmTokenInfo(Alamofire.Result<Token?>)
    }

    struct State {
        var resultString: String?
        var viteURI: ViteURI?
        var confirmedToken: Token?
        var isLoading: Bool
        var toastMessage: String?
        var alertMessage: String?
    }

    var initialState: State

    init() {
        self.initialState = State(resultString: nil,
                                  viteURI: nil,
                                  confirmedToken: nil,
                                  isLoading: false,
                                  toastMessage: nil,
                                  alertMessage: nil)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .pickeImage(pickedImage):
            return Observable.concat([
                Observable.just(Mutation.processImage(pickedImage)),
                Observable.just(Mutation.creatURI),
                Observable.just(Mutation.setLoading(true)),
                self.fetchTokenInfo().map { Mutation.confirmTokenInfo($0) },
                Observable.just(Mutation.setLoading(false)),
            ])
        case let .scanQRCode(metadataObject):
            return Observable.concat([
                Observable.just(Mutation.processAVMetadata(metadataObject)),
                Observable.just(Mutation.creatURI),
                Observable.just(Mutation.setLoading(true)),
                self.fetchTokenInfo().map { Mutation.confirmTokenInfo($0) },
                Observable.just(Mutation.setLoading(false)),
                ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.toastMessage = nil; newState.alertMessage = nil
        switch mutation {
        case let .processImage(pickedImage):
            (newState.resultString, newState.toastMessage) = self.processImage(pickedImage)
        case let .processAVMetadata(metadata):
            newState.resultString = self.processAVMetadata(metadata)
        case .creatURI:
            (newState.viteURI, newState.alertMessage ) = self.creatURI(newState.resultString)
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        case let .confirmTokenInfo(result):
            (newState.confirmedToken, newState.toastMessage) = self.confirmTokenInfo(result: result)
        }
        return newState
    }

    func processImage(_ image: UIImage?) -> (resultString: String?, toastString: String?) {
        var resultString: String?
        var toastString: String? = R.string.localizable.scanPageQccodeNotFound.key.localized()

        guard let image = image, let ciImage = CIImage.init(image: image) else {
            return (resultString, toastString)
        }
        var options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let context = CIContext()
        let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
        if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)) {
            options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
        } else {
            options = [CIDetectorImageOrientation: 1]
        }

        guard let features = qrDetector?.features(in: ciImage, options: options), !features.isEmpty else {
            return (resultString, toastString)
        }
        for case let row as CIQRCodeFeature in features {
            resultString = row.messageString
        }
        if resultString != nil {
            toastString = nil
        }
        return (resultString, toastString)
    }

    func processAVMetadata(_ metadataObject: AVMetadataObject?) -> String? {
        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return nil }
        return readableObject.stringValue
    }

    func creatURI(_ string: String?) -> (viteURI: ViteURI?, alertString: String?) {
        var viteURI: ViteURI?
        var alertString: String?
        guard let resultString = string else {
            return (viteURI, alertString)
        }
        if let uri = ViteURI.parser(string: resultString) {
            switch uri {
            case .transfer:
                viteURI = uri
            }
        } else {
            alertString = resultString
        }
        return (viteURI, alertString)
    }

    func confirmTokenInfo(result: Result<Token?>?) -> (token: Token?, toastString: String?) {
        var confirmedToken: Token?
        var toastString: String?
        guard let result = result else {
            return (confirmedToken, toastString)
        }
        switch result {
        case .success(let token):
            if token != nil {
                confirmedToken = token
            } else {
                toastString = R.string.localizable.sendPageTokenInfoError.key.localized()
            }
        case .failure(let error):
            toastString = error.localizedDescription
        }
        return (confirmedToken, toastString)
    }

    func fetchTokenInfo() -> Observable<Alamofire.Result<Token?>> {
        return Observable<Alamofire.Result<Token?>>.create({ [weak self] (observer) -> Disposable in
            if let uri = self?.currentState.viteURI {
                switch uri {
                case .transfer(_, let tokenId, _, _, _):
                    let tokenId = tokenId ?? TokenCacheService.instance.viteToken.id
                    TokenCacheService.instance.tokenForId(tokenId) {(result) in
                        observer.onNext(result)
                        observer.onCompleted()
                    }
                }
            } else {
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }

}
