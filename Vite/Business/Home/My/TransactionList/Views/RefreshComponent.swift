//
//  RefreshHeader.swift
//  Vite
//
//  Created by Stone on 2018/9/30.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import MJRefresh
import SnapKit

class RefreshHeader: MJRefreshHeader {

    lazy var stateLabel = UILabel().then {
        $0.font = Fonts.light14
        $0.textColor = Colors.cellTitleGray
        $0.textAlignment = .center
        addSubview($0)
    }

    var stateTitles = NSMutableDictionary()

    override func placeSubviews() {
        super.placeSubviews()
        stateLabel.frame = bounds
    }

    override var state: MJRefreshState {
        didSet {
            switch state {
            case .idle:
                stateLabel.text = R.string.localizable.transactionListPageHeaderRefreshIdle()
            case .pulling:
                stateLabel.text = R.string.localizable.transactionListPageHeaderRefreshPulling()
            case .refreshing:
                stateLabel.text = R.string.localizable.transactionListPageHeaderRefreshRefreshing()
            default:
                break
            }
        }
    }

}

final class RefreshFooter: MJRefreshBackNormalFooter {

    class func footer(refreshingBlock: @escaping MJRefreshComponentRefreshingBlock) -> RefreshFooter? {
        let footer = RefreshFooter.init(refreshingBlock: refreshingBlock)
        footer?.setTitle(R.string.localizable.viteRefreshBackFooterIdleText(), for: .idle)
        footer?.setTitle(R.string.localizable.viteRefreshBackFooterPullingText(), for: .pulling)
        footer?.setTitle(R.string.localizable.viteRefreshBackFooterRefreshingText(), for: .refreshing)
        footer?.setTitle(R.string.localizable.viteRefreshBackFooterNoMoreDataText(), for: .noMoreData)
        return footer
    }

}
