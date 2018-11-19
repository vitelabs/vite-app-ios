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
                stateLabel.text = R.string.localizable.transactionListPageHeaderRefreshIdle.key.localized()
            case .pulling:
                stateLabel.text = R.string.localizable.transactionListPageHeaderRefreshPulling.key.localized()
            case .refreshing:
                stateLabel.text = R.string.localizable.transactionListPageHeaderRefreshRefreshing.key.localized()
            default:
                break
            }
        }
    }

}

final class RefreshFooter: MJRefreshBackNormalFooter {

    class func footer(refreshingBlock: @escaping MJRefreshComponentRefreshingBlock) -> RefreshFooter? {
        let footer = RefreshFooter.init(refreshingBlock: refreshingBlock)
        footer?.setTitle(R.string.localizable.viteRefreshBackFooterIdleText.key.localized(), for: .idle)
        footer?.setTitle(R.string.localizable.viteRefreshBackFooterPullingText.key.localized(), for: .pulling)
        footer?.setTitle(R.string.localizable.viteRefreshBackFooterRefreshingText.key.localized(), for: .refreshing)
        footer?.setTitle(R.string.localizable.viteRefreshBackFooterNoMoreDataText.key.localized(), for: .noMoreData)
        return footer
    }

}
