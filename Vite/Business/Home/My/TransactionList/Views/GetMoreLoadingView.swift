//
//  GetMoreLoadingView.swift
//  Vite
//
//  Created by Stone on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

class GetMoreLoadingView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = UIColor.green
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.startAnimating()
        contentView.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { (m) in
            m.center.equalTo(contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
