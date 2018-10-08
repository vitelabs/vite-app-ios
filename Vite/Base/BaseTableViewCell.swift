//
//  BaseTableViewCell.swift
//  Vite
//
//  Created by Stone on 2018/8/28.
//  Copyright © 2018年 Vite. All rights reserved.
//

import UIKit

import RxSwift

class BaseTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
