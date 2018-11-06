//
//  ImageWrapper.swift
//  Vite
//
//  Created by Stone on 2018/11/6.
//  Copyright © 2018 vite labs. All rights reserved.
//

import Foundation
import Kingfisher

enum ImageWrapper {
    case url(url: URL)
    case image(image: UIImage)

    func putIn(_ imageView: UIImageView) {
        imageView.kf.cancelDownloadTask()
        switch self {
        case .image(let image):
            imageView.image = image
        case .url(let url):
            imageView.kf.setImage(with: url)
        }
    }
}
