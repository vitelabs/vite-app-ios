//
//  BussinessErrorHandler.swift
//  Vite
//
//  Created by haoshenyang on 2018/11/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation

struct BussinessErrorHandler {

    static func hander(error: Error, in viewController: UIViewController) -> Bool {

        if error.code == Provider.TransactionErrorCode.notEnoughBalance.rawValue {
            Alert.show(into: viewController,
                       title: R.string.localizable.sendPageNotEnoughBalanceAlertTitle(),
                       message: nil,
                       actions: [(.default(title: R.string.localizable.sendPageNotEnoughBalanceAlertButton()), nil)])
            return true
        } else if error.code == Provider.TransactionErrorCode.notEnoughQuota.rawValue {
            Alert.show(into: viewController, title: R.string.localizable.quotaAlertTitle(), message: R.string.localizable.quotaAlertNeedQuotaMessage(), actions: [
                (.default(title: R.string.localizable.quotaAlertQuotaButtonTitle()), { [weak viewController] _ in
                    let vc = QuotaManageViewController()
                    viewController?.navigationController?.pushViewController(vc, animated: true)
                }),
                (.default(title: R.string.localizable.quotaAlertPowButtonTitle()), { _ in

                }),
                (.cancel, nil),
                ], config: { alert in
                    alert.preferredAction = alert.actions[0]
            })
            return true
        }
        return false
    }

}
