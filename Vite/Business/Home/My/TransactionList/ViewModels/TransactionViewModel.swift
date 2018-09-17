//
//  TransactionViewModel.swift
//  Vite
//
//  Created by Stone on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

final class TransactionViewModel: TransactionViewModelType {
    let typeImage: UIImage
    let timeString: String
    let hash: String
    let balanceString: String
    let symbolString: String

    init(transaction: Transaction) {
        self.typeImage = (transaction.type == .request ? R.image.icon_tx_send() : R.image.icon_tx_recieve())!
        self.timeString = transaction.timestamp.format()
        self.hash = transaction.hash
        let symbol = transaction.type == .request ? "-" : "+"
        self.balanceString = "\(symbol)\(transaction.amount.amountShort)"
        self.symbolString = TokenCacheService.instance.tokenForId(transaction.tokenId)?.symbol ?? ""
    }
}
