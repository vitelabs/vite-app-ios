//
//  UIView+Helper.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    public var safeAreaLayoutGuideSnp: ConstraintAttributesDSL {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.snp
        } else {
            return self.snp
        }
    }
}
