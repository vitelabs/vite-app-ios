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
    }

    struct State {
        var resultString: String?
        var result: ScanResult?
        var toastMessage: String?
        var alertMessage: String?
    }

    var initialState: State

    init() {
        self.initialState = State(
            resultString: nil,
            result: nil,
            toastMessage: nil,
            alertMessage: nil)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .pickeImage(pickedImage):
            return Observable.concat([
                Observable.just(Mutation.processImage(pickedImage)),
                Observable.just(Mutation.creatURI),
            ])
        case let .scanQRCode(metadataObject):
            return Observable.concat([
                Observable.just(Mutation.processAVMetadata(metadataObject)),
                Observable.just(Mutation.creatURI),
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
            (newState.result, newState.alertMessage ) = self.creatURI(newState.resultString)
        }
        return newState
    }

    func processImage(_ image: UIImage?) -> (resultString: String?, toastString: String?) {
        var resultString: String?
        var toastString: String? = R.string.localizable.scanPageQccodeNotFound()

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

    func creatURI(_ string: String?) -> (result: ScanResult?, alertString: String?) {
        var scanResult: ScanResult
        var alertString: String?
        if let string = string, let uri = ViteURI.parser(string: string) {
            scanResult = .viteURI(uri)
        } else {
            scanResult = .otherString(string)
            alertString = string
        }
        return (scanResult, alertString)
    }

}
