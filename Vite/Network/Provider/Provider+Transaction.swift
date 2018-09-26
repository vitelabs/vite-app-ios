//
//  Provider+Transaction.swift
//  Vite
//
//  Created by Stone on 2018/9/20.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import Foundation
import PromiseKit
import JSONRPCKit
import APIKit
import BigInt

extension Provider {

    fileprivate func getUnconfirmedTransaction(address: Address) -> Promise<(accountBlocks: [AccountBlock], latestAccountBlock: AccountBlock, snapshotChainHash: String)> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory()
                .create(GetUnconfirmedTransactionRequest(address: address.description),
                        GetLatestAccountBlockRequest(address: address.description),
                        GetLatestSnapshotChainHashRequest()))
            Session.send(request) { result in
                switch result {
                case .success(let accountBlocks, let latestAccountBlock, let snapshotChainHash):
                    seal.fulfill((accountBlocks, latestAccountBlock, snapshotChainHash))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    fileprivate func getLatestAccountBlockAndSnapshotChainHash(address: Address) -> Promise<(latestAccountBlock: AccountBlock, snapshotChainHash: String)> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory()
                .create(GetLatestAccountBlockRequest(address: address.description),
                        GetLatestSnapshotChainHashRequest()))
            Session.send(request) { result in
                switch result {
                case .success(let latestAccountBlock, let snapshotChainHash):
                    seal.fulfill((latestAccountBlock, snapshotChainHash))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    fileprivate func createTransaction(accountBlock: AccountBlock) -> Promise<Void> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(CreateTransactionRequest(accountBlock: accountBlock)))
            Session.send(request) { result in
                switch result {
                case .success:
                    seal.fulfill(Void())
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

extension Provider {

    enum TransactionErrorCode: Int {
        case notEnoughBalance = -35001
    }

    func receiveTransaction(bag: HDWalletManager.Bag, completion: @escaping (NetworkResult<Void>) -> Void) {
        getUnconfirmedTransaction(address: bag.address)
            .then({ [weak self] (accountBlocks, latestAccountBlock, latestSnapshotChainHash) -> Promise<Void> in
                guard let `self` = self else { return Promise { $0.fulfill(Void()) } }
                if let accountBlock = accountBlocks.first {
                    let receive = AccountBlock.makeReceiveAccountBlock(unconfirmed: accountBlock,
                                                                       latest: latestAccountBlock,
                                                                       bag: bag,
                                                                       snapshotChainHash: latestSnapshotChainHash)
                    return self.createTransaction(accountBlock: receive)
                } else {
                    return Promise { $0.fulfill(Void()) }
                }
            })
            .done({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    func sendTransaction(bag: HDWalletManager.Bag,
                         toAddress: Address,
                         tokenId: String,
                         amount: BigInt,
                         note: String?,
                         completion: @escaping (NetworkResult<Void>) -> Void) {

        getLatestAccountBlockAndSnapshotChainHash(address: bag.address)
            .then({ [weak self] (latestAccountBlock, latestSnapshotChainHash) -> Promise<Void> in
                guard let `self` = self else { return Promise { $0.fulfill(Void()) } }
                let send = AccountBlock.makeSendAccountBlock(latest: latestAccountBlock,
                                                             bag: bag,
                                                             snapshotChainHash: latestSnapshotChainHash,
                                                             toAddress: toAddress,
                                                             tokenId: tokenId,
                                                             amount: amount,
                                                             data: note)
                return self.createTransaction(accountBlock: send)
            })
            .done ({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }
}
