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
    let typeName: String
    let address: String
    let timeString: String
    let balanceString: String
    let balanceColor: UIColor
    let symbolString: String
    let hash: String

    init(transaction: Transaction) {
        self.typeImage = transaction.type.icon
        self.typeName = transaction.type.name
        self.address = transaction.type == .receive ? transaction.fromAddress.description : transaction.toAddress.description
        self.timeString = transaction.timestamp.format("yyyy.MM.dd")
        let symbol = transaction.amount.value == 0 ? "" : (transaction.type == .receive ? "+" : "-")
        self.balanceString = "\(symbol)\(transaction.amount.amountShort(decimals: transaction.token.decimals))"
        self.balanceColor = transaction.type == .receive ? UIColor(netHex: 0xFF0008) : UIColor(netHex: 0x5BC500)
        self.symbolString = TokenCacheService.instance.tokenForId(transaction.token.id)?.symbol ?? ""
        self.hash = transaction.hash
    }
}

extension Transaction.TransactionType {
    var name: String {
        switch self {
        case .register:
            return R.string.localizable.transactionListTransactionTypeNameRegister()
        case .registerUpdate:
            return R.string.localizable.transactionListTransactionTypeNameRegisterUpdate()
        case .cancelRegister:
            return R.string.localizable.transactionListTransactionTypeNameCancelRegister()
        case .extractReward:
            return R.string.localizable.transactionListTransactionTypeNameExtractReward()
        case .vote:
            return R.string.localizable.transactionListTransactionTypeNameVote()
        case .cancelVote:
            return R.string.localizable.transactionListTransactionTypeNameCancelVote()
        case .pledge:
            return R.string.localizable.transactionListTransactionTypeNamePledge()
        case .cancelPledge:
            return R.string.localizable.transactionListTransactionTypeNameCancelPledge()
        case .coin:
            return R.string.localizable.transactionListTransactionTypeNameCoin()
        case .cancelCoin:
            return R.string.localizable.transactionListTransactionTypeNameCancelCoin()
        case .send, .receive:
            return R.string.localizable.transactionListTransactionTypeNameTransfer()
        }
    }

    var icon: UIImage! {
        switch self {
        case .register, .registerUpdate, .cancelRegister:
            return R.image.icon_tx_register()
        case .extractReward:
            return R.image.icon_tx_reward()
        case .vote, .cancelVote:
            return R.image.icon_tx_vote()
        case .pledge, .cancelPledge:
            return R.image.icon_tx_pledge()
        case .coin, .cancelCoin:
            return R.image.icon_tx_coin()
        case .send, .receive:
            return R.image.icon_tx_transfer()
        }
    }
}
