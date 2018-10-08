//
//  CellSeparatorLine.swift
//  Vite
//
//  Created by Water on 2018/9/25.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

private var kbottomSeparatorLineKey: UInt8 = 0
extension UITableViewCell: CellSeparatorLine {

    var bottomSeparatorLine: LineView {
        get {
            if let bottomSeparatorLine = objc_getAssociatedObject(self, &kbottomSeparatorLineKey) as? LineView {
                return bottomSeparatorLine
            }
            let bottomSeparatorLine = LineView.init(direction: .horizontal)
            bottomSeparatorLine.isHidden = true
            bottomSeparatorLine.backgroundColor = Colors.lineGray
            bottomSeparatorLine.alpha = 1.0
            self.addSubview(bottomSeparatorLine)
            bottomSeparatorLine.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(24)
                make.right.equalTo(self).offset(-24)
                make.bottom.equalTo(self).offset(-1)
                make.height.equalTo(CGFloat.singleLineWidth)
            })
            objc_setAssociatedObject(self, &kbottomSeparatorLineKey, bottomSeparatorLine, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return bottomSeparatorLine
        }
        set {
            objc_setAssociatedObject(self, &kbottomSeparatorLineKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}

protocol CellSeparatorLine: class {
    var bottomSeparatorLine: LineView { get }
}
