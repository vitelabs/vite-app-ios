//
//  TransactionListTableViewModel.swift
//  Vite
//
//  Created by Stone on 2018/9/11.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TransactionListTableViewModel: TransactionListTableViewModelType {

    enum LoadingStatus {
        case no
        case refresh
        case more
    }

    lazy var transactionsDriver: Driver<[TransactionViewModelType]> = self.transactions.asDriver()
    let hasMore: BehaviorRelay<Bool>

    fileprivate let transactions: BehaviorRelay<[TransactionViewModelType]>
    fileprivate let address: Address
    fileprivate let disposeBag = DisposeBag()

    fileprivate let viewModels = NSMutableArray()
    fileprivate var index = 0
    fileprivate var hash: String?
    fileprivate var loadingStatus = LoadingStatus.no

    init(address: Address) {
        self.address = address
        transactions = BehaviorRelay<[TransactionViewModelType]>(value: viewModels as! [TransactionViewModelType])
        hasMore = BehaviorRelay<Bool>(value: false)
    }

    func refreshList(_ completion: @escaping (Error?) -> Void) {
        guard loadingStatus == .no else { return }
        loadingStatus = .refresh
        index = 0
        hash = nil
        viewModels.removeAllObjects()
        getTransactions(completion: completion)
    }

    func getMore(_ completion: @escaping (Error?) -> Void) {
        guard loadingStatus == .no else { return }
        loadingStatus = .more
        index += 1
        getTransactions(completion: completion)
    }

    private func getTransactions(completion: @escaping (Error?) -> Void) {

        Provider.instance.getTransactions(address: address, hash: hash, count: 10) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success((let transactions, let hasMore)):
                self.getTokensIfNeeded(ids: transactions.map { $0.tokenId }, completion: { (error) in

                    if let error = error {
                        self.loadingStatus = .no
                        completion(error)
                    } else {
                        self.hash = transactions.last?.hash
                        self.viewModels.addObjects(from: transactions.map {
                            TransactionViewModel(transaction: $0)
                        })
                        self.transactions.accept(self.viewModels as! [TransactionViewModelType])
                        self.hasMore.accept(hasMore)
                        self.loadingStatus = .no
                        completion(nil)
                    }
                })
            case .error(let error):
                self.loadingStatus = .no
                completion(error)
            }
        }
    }

    private func getTokensIfNeeded(ids: [String], completion: @escaping (Error?) -> Void) {

        var tokenIds = ids
        if let id = tokenIds.first {
            tokenIds.removeFirst()
            if let _ = TokenCacheService.instance.tokenForId(id) {
                getTokensIfNeeded(ids: tokenIds, completion: completion)
            } else {
                Provider.instance.getTokenForId(id) { [weak self] result in
                    guard let `self` = self else { return }
                    switch result {
                    case .success(let token):
                        TokenCacheService.instance.updateTokensIfNeeded([token])
                        self.getTokensIfNeeded(ids: tokenIds, completion: completion)
                    case .error(let error):
                        completion(error)
                    }
                }
            }
        } else {
            completion(nil)
        }
    }
}
