//
//  QRCodeHelper.swift
//  Vite
//
//  Created by Stone on 2018/9/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

struct QRCodeHelper {
    static func createQRCode(string: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let context = CIContext()
            let data = string.data(using: String.Encoding.ascii)
            guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return }
            filter.setValue(data, forKey: "inputMessage")
            guard let output = filter.outputImage?.transformed(by: CGAffineTransform(scaleX: 7, y: 7)),
                let cgImage = context.createCGImage(output, from: output.extent) else {
                    completion(nil)
                    return
            }
            DispatchQueue.main.async {
                completion(UIImage(cgImage: cgImage))
            }
        }
    }
}
