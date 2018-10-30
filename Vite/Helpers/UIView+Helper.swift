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

    public var safeAreaLayoutGuideSnpTop: ConstraintItem {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.snp.top
        } else {
            if let vc = __viewController {
                return vc.topLayoutGuide.snp.bottom
            } else {
                return self.snp.top
            }
        }
    }

    public var safeAreaLayoutGuideSnpBottom: ConstraintItem {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.snp.bottom
        } else {
            return self.snp.bottom
        }
    }

    public var safeAreaLayoutGuideSnpLeft: ConstraintItem {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.snp.left
        } else {
            return self.snp.left
        }
    }

    public var safeAreaLayoutGuideSnpRight: ConstraintItem {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.snp.right
        } else {
            return self.snp.right
        }
    }

    public var ofViewController: UIViewController? {
        return __viewController
    }

    private var __viewController: UIViewController? {
        var next = self.next
        while next != nil {
            if let n = next as? UIViewController {
                return n
            } else if let n = next {
                next = n.next
            }
        }

        return nil
    }
}
