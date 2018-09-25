//
//  CellSeparatorLine.swift
//  Vite
//
//  Created by Water on 2018/9/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

private var kdownSeparatorLineKey: UInt8 = 0
extension UITableViewCell: CellSeparatorLine {

    var downSeparatorLine: LineView {
        get {
            if let downSeparatorLine = objc_getAssociatedObject(self, &kdownSeparatorLineKey) as? LineView {
                return downSeparatorLine
            }
            let downSeparatorLine = LineView.init(direction: .horizontal)
            downSeparatorLine.isHidden = true
            downSeparatorLine.backgroundColor = Colors.lineGray
            downSeparatorLine.alpha = 1.0
            self.addSubview(downSeparatorLine)
            downSeparatorLine.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(24)
                make.right.equalTo(self).offset(-24)
                make.bottom.equalTo(self).offset(-1)
                make.height.equalTo(1)
            })
            objc_setAssociatedObject(self, &kdownSeparatorLineKey, downSeparatorLine, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return downSeparatorLine
        }
        set {
            objc_setAssociatedObject(self, &kdownSeparatorLineKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}

protocol CellSeparatorLine: class {
    var downSeparatorLine: LineView { get }
}
