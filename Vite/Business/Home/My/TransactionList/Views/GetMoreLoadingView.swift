//
//  GetMoreLoadingView.swift
//  Vite
//
//  Created by Stone on 2018/9/12.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class GetMoreLoadingView: UITableViewHeaderFooterView {

    enum Status {
        case loading
        case failed
    }

    var status: Status = .loading {
        didSet {
            activityIndicatorView.isHidden = status != .loading
            retryButton.isHidden = status != .failed
        }
    }

    var retry: Observable<Void> {
        return retryButton.rx.tap.asObservable()
    }

    fileprivate let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    fileprivate let retryButton = UIButton().then {
        $0.setTitle(R.string.localizable.sendPageConfirmPasswordAuthFailedRetry(), for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(activityIndicatorView)
        contentView.addSubview(retryButton)
        retryButton.isHidden = true
        activityIndicatorView.startAnimating()
        retryButton.snp.makeConstraints { (m) in
            m.edges.equalTo(contentView)
        }
        activityIndicatorView.snp.makeConstraints { (m) in
            m.center.equalTo(contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
