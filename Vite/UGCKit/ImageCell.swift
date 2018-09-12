//
//  ImageCell.swift
//  Vite
//
//  Created by Water on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Eureka
import SnapKit

public class ImageCell: Cell<Bool>, CellType {
    public lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        titleLab.textAlignment = .left
        return titleLab
    }()

    public lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.backgroundColor = .clear
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.contentMode = .scaleAspectFit
        return rightImageView
    }()

    public override func setup() {
        super.setup()
        contentView.addSubview(titleLab)
        contentView.addSubview(rightImageView)

        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(30)
            make.centerY.equalTo(contentView)
        }

        self.rightImageView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-30)
            make.centerY.equalTo(contentView)
        }
        self.height = { 66 }
    }

    public override func update() {
        super.update()
    }

}

public final class ImageRow: Row<ImageCell>, RowType {
    open var routeVCClassName = ""

    required public init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<ImageCell>()
    }

    open override func customDidSelect() {
        guard !isDisabled else {
            super.customDidSelect()
            return
        }
        deselect()
        if !isDisabled {
            if routeVCClassName.isEmpty {
                return
            }
            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            // transform into anyClass
            let cls: AnyClass = NSClassFromString(namespace + "." + routeVCClassName)!
            guard let VC = cls as? UIViewController.Type   else {
                return
            }
            let vc = VC.init()
            self.cell.formViewController()?.navigationController?.pushViewController( vc, animated: true)
        }
    }
}
