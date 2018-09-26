//
//  ScrollableView.swift
//  Vite
//
//  Created by Stone on 2018/9/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class ScrollableView: UIScrollView {

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: frame.width, height: contentSize.height)
    }
}
