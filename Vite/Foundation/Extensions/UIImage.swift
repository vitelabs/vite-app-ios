//
//  UIImage.swift
//  Vite
//
//  Created by Water on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

extension UIImage {
    public static func color(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(color.cgColor)
        ctx?.fill(rect)
        var image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        image = UIImage(data: imageData)!
        return image
    }

    public var highlighted: UIImage {
        return alpha(0.6)
    }

    public func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    public var resizable: UIImage {
        let halfHeight = size.height / 2
        let halfWidth = size.width / 2
        return resizableImage(withCapInsets: UIEdgeInsets(top: halfHeight, left: halfWidth, bottom: halfHeight, right: halfWidth),
                              resizingMode: .stretch)
    }

    public func tintColor(_ tintColor: UIColor) -> UIImage {
        return p_tintColor(tintColor, blendMode: .destinationIn)
    }

    public func gradientTintColor(_ tintColor: UIColor) -> UIImage {
        return p_tintColor(tintColor, blendMode: .overlay)
    }

    fileprivate func p_tintColor(_ tintColor: UIColor, blendMode: CGBlendMode) -> UIImage {
        //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        tintColor.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)

        //Draw the tinted image in context
        draw(in: bounds, blendMode: blendMode, alpha: 1.0)
        if blendMode != .destinationIn {
            draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        }

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
