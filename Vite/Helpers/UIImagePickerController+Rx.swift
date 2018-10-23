//
//  UIImagePickerController+Rx.swift
//  Vite
//
//  Created by haoshenyang on 2018/10/17.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

public protocol ImagePickerControllerDelegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

}

extension UIImagePickerController {
    public typealias Delegate = ImagePickerControllerDelegate
}

public class RxImagePickerDelegateProxy: DelegateProxy<UIImagePickerController, ImagePickerControllerDelegate>,
    DelegateProxyType,
    ImagePickerControllerDelegate {

    public init(imagePicker: UIImagePickerController) {
    super.init(parentObject: imagePicker, delegateProxy: RxImagePickerDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxImagePickerDelegateProxy(imagePicker: $0) }
    }

    public static func currentDelegate(for object: UIImagePickerController) -> (ImagePickerControllerDelegate)? {
        return object.delegate as? (ImagePickerControllerDelegate)
    }

    public static func setCurrentDelegate(_ delegate: ImagePickerControllerDelegate?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
}

extension Reactive where Base: UIImagePickerController {

    public var pickerDelegate: DelegateProxy<UIImagePickerController, ImagePickerControllerDelegate> {
        return RxImagePickerDelegateProxy.proxy(for: base)
    }

    var didFinishPickingMediaWithInfo: Observable<[String: AnyObject]> {
        return pickerDelegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map({ (a) in
                guard let returnValue = a[1] as? [String: AnyObject] else {
                    throw RxCocoaError.castingError(object: a[1], targetType: [String: AnyObject].self)
                }
                return returnValue
            })
    }

    var didCancel: Observable<()> {
        return pickerDelegate
            .methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map { _ in () }
    }

}
