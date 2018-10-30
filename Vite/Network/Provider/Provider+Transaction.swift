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

    fileprivate func getUnconfirmedTransaction(address: Address) -> Promise<(accountBlocks: [AccountBlock], latestAccountBlock: AccountBlock, snapshotHash: String)> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory()
                .create(GetUnconfirmedTransactionRequest(address: address.description),
                        GetLatestAccountBlockRequest(address: address.description),
                        GetLatestSnapshotHashRequest()))
            Session.send(request) { result in
                switch result {
                case .success(let accountBlocks, let latestAccountBlock, let snapshotHash):
                    seal.fulfill((accountBlocks, latestAccountBlock, snapshotHash))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    fileprivate func getLatestAccountBlockAndSnapshotHash(address: Address) -> Promise<(latestAccountBlock: AccountBlock, snapshotHash: String)> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory()
                .create(GetLatestAccountBlockRequest(address: address.description),
                        GetLatestSnapshotHashRequest()))
            Session.send(request) { result in
                switch result {
                case .success(let latestAccountBlock, let snapshotHash):
                    seal.fulfill((latestAccountBlock, snapshotHash))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    fileprivate func getPowNonce(address: Address, preHash: String?) -> Promise<String> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetPowNonceRequest(address: address, preHash: preHash)))
            Session.send(request) { result in
                switch result {
                case .success(let nonce):
                    seal.fulfill(nonce)
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
            .then({ [unowned self] (accountBlocks, latestAccountBlock, latestSnapshotHash) -> Promise<(accountBlock: AccountBlock, latestAccountBlock: AccountBlock, latestSnapshotHash: String, nonce: String)?> in
                if let accountBlock = accountBlocks.first {
                    return self.getPowNonce(address: bag.address, preHash: latestAccountBlock.hash).then({ nonce in
                        return Promise { seal in seal.fulfill((accountBlock, latestAccountBlock, latestSnapshotHash, nonce)) }
                    })
                } else {
                    return Promise { $0.fulfill(nil) }
                }
            })
            .then({ [unowned self] ret -> Promise<Void> in
                if let (accountBlock, latestAccountBlock, latestSnapshotHash, nonce) = ret {
                    let receive = AccountBlock.makeReceiveAccountBlock(unconfirmed: accountBlock,
                                                                       latest: latestAccountBlock,
                                                                       bag: bag,
                                                                       snapshotHash: latestSnapshotHash,
                                                                       nonce: nonce)
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

        getLatestAccountBlockAndSnapshotHash(address: bag.address)
            .then({ [unowned self] (latestAccountBlock, latestSnapshotHash) -> Promise<(latestAccountBlock: AccountBlock, latestSnapshotHash: String, nonce: String)> in
                return self.getPowNonce(address: bag.address, preHash: latestAccountBlock.hash).then({ nonce in
                    return Promise { seal in seal.fulfill((latestAccountBlock, latestSnapshotHash, nonce)) }
                })
            })
            .then({ [unowned self] (latestAccountBlock, latestSnapshotHash, nonce) -> Promise<Void> in
                let send = AccountBlock.makeSendAccountBlock(latest: latestAccountBlock,
                                                             bag: bag,
                                                             snapshotHash: latestSnapshotHash,
                                                             toAddress: toAddress,
                                                             tokenId: tokenId,
                                                             amount: amount,
                                                             data: note,
                                                             nonce: nonce)
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
