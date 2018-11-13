//
//  AVCaptureMetadataOutput+Rx.swift
//  Vite
//
//  Created by haoshenyang on 2018/10/17.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import AVFoundation
import RxSwift
import RxCocoa

extension AVCaptureMetadataOutput: HasDelegate {
    public var delegate: AVCaptureMetadataOutputObjectsDelegate? {
        get {
            return self.metadataObjectsDelegate
        }
        set(newValue) {
            self.setMetadataObjectsDelegate(newValue, queue: DispatchQueue.main)
        }
    }

    public typealias Delegate = AVCaptureMetadataOutputObjectsDelegate
}

class RxAVCaptureMetadataOutputObjectsDelegateProxy: DelegateProxy<AVCaptureMetadataOutput, AVCaptureMetadataOutputObjectsDelegate>, DelegateProxyType, AVCaptureMetadataOutputObjectsDelegate {

    public weak private(set) var metadataOutput: AVCaptureMetadataOutput?

    public init(metadataOutput: ParentObject) {
        self.metadataOutput = metadataOutput
        super.init(parentObject: metadataOutput, delegateProxy: RxAVCaptureMetadataOutputObjectsDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxAVCaptureMetadataOutputObjectsDelegateProxy(metadataOutput: $0) }
    }
}

extension Reactive where Base: AVCaptureMetadataOutput {
    public var delegate: DelegateProxy<AVCaptureMetadataOutput, AVCaptureMetadataOutputObjectsDelegate> {
        return RxAVCaptureMetadataOutputObjectsDelegateProxy.proxy(for: base)
    }

    var metadataOutput: Observable<[AVMetadataObject]> {
        return delegate.methodInvoked(#selector(AVCaptureMetadataOutputObjectsDelegate.metadataOutput(_:didOutput:from:)))
            .map { parameters in
                return parameters[1] as! [AVMetadataObject]
            }
    }
}
