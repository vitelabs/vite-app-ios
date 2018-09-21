//
//  LineView.swift
//  Vite
//
//  Created by Water on 2018/9/21.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

enum LineViewDirection {
    case horizontal
    case vertical
}

class LineView: UIView {

    init(direction: LineViewDirection) {
        super.init(frame: CGRect.zero)

        self.backgroundColor = .white
        self.alpha = 0.3
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
