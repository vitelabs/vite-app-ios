//
//  UITableView+Helper.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

private var kRegisteredCellClasses: UInt8 = 0

extension UITableView {

    public var registeredCellClasses: Set<String> {
        get {
            if let registeredCellClasses = objc_getAssociatedObject(self, &kRegisteredCellClasses) as? Set<String> {
                return registeredCellClasses
            } else {
                let registeredCellClasses: Set<String> = []
                objc_setAssociatedObject(self, &kRegisteredCellClasses, registeredCellClasses, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return registeredCellClasses
            }
        }

        set {
            objc_setAssociatedObject(self, &kRegisteredCellClasses, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        let name = NSStringFromClass(Cell.self)
        if !registeredCellClasses.contains(name) { register(Cell.self, forCellReuseIdentifier: name) }
        guard let cell = dequeueReusableCell(withIdentifier: name, for: indexPath) as? Cell else { fatalError("Unexpected cell type at \(indexPath)") }
        return cell
    }
}
