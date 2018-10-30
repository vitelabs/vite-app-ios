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

// MARK: Transaction
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

    fileprivate func getPowNonce(address: Address, preHash: String?, difficulty: BigInt) -> Promise<String> {
        return Promise { seal in
            var request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetPowNonceRequest(address: address, preHash: preHash, difficulty: difficulty)))
            request.timeoutInterval = 60.0
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
        case notEnoughQuota = -35002
    }

    func receiveTransactionWithoutGetPow(bag: HDWalletManager.Bag, completion: @escaping (NetworkResult<Void>) -> Void) {
        getUnconfirmedTransaction(address: bag.address)
            .then({ (accountBlocks, latestAccountBlock, latestSnapshotHash) -> Promise<(accountBlock: AccountBlock, latestAccountBlock: AccountBlock, latestSnapshotHash: String)?> in
                if let accountBlock = accountBlocks.first {
                    return Promise { seal in seal.fulfill((accountBlock, latestAccountBlock, latestSnapshotHash)) }
                } else {
                    return Promise { $0.fulfill(nil) }
                }
            })
            .then({ [unowned self] ret -> Promise<Void> in
                if let (accountBlock, latestAccountBlock, latestSnapshotHash) = ret {
                    let receive = AccountBlock.makeReceiveAccountBlock(unconfirmed: accountBlock,
                                                                       latest: latestAccountBlock,
                                                                       bag: bag,
                                                                       snapshotHash: latestSnapshotHash,
                                                                       nonce: nil,
                                                                       difficulty: nil)
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

    func receiveTransactionWithGetPow(bag: HDWalletManager.Bag, difficulty: BigInt, completion: @escaping (NetworkResult<Void>) -> Void) {
        getUnconfirmedTransaction(address: bag.address)
            .then({ [unowned self] (accountBlocks, latestAccountBlock, latestSnapshotHash) -> Promise<(accountBlock: AccountBlock, latestAccountBlock: AccountBlock, latestSnapshotHash: String, nonce: String)?> in
                if let accountBlock = accountBlocks.first {
                    return self.getPowNonce(address: bag.address, preHash: latestAccountBlock.hash, difficulty: difficulty).then({ nonce in
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
                                                                       nonce: nonce,
                                                                       difficulty: difficulty)
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

    func sendTransactionWithoutGetPow(bag: HDWalletManager.Bag,
                                      toAddress: Address,
                                      tokenId: String,
                                      amount: BigInt,
                                      data: String?,
                                      completion: @escaping (NetworkResult<Void>) -> Void) {

        getLatestAccountBlockAndSnapshotHash(address: bag.address)
            .then({ [unowned self] (latestAccountBlock, latestSnapshotHash) -> Promise<Void> in
                let send = AccountBlock.makeSendAccountBlock(latest: latestAccountBlock,
                                                             bag: bag,
                                                             snapshotHash: latestSnapshotHash,
                                                             toAddress: toAddress,
                                                             tokenId: tokenId,
                                                             amount: amount,
                                                             data: data,
                                                             nonce: nil,
                                                             difficulty: nil)
                return self.createTransaction(accountBlock: send)
            })
            .done ({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    struct SendTransactionContext {
        let latestAccountBlock: AccountBlock
        let bag: HDWalletManager.Bag
        let latestSnapshotHash: String
        let toAddress: Address
        let tokenId: String
        let amount: BigInt
        let data: String?
        let nonce: String?
        let difficulty: BigInt?
    }

    func sendTransactionWithGetPow(bag: HDWalletManager.Bag,
                                   toAddress: Address,
                                   tokenId: String,
                                   amount: BigInt,
                                   data: String?,
                                   difficulty: BigInt,
                                   completion: @escaping (NetworkResult<SendTransactionContext>) -> Void) {

        getLatestAccountBlockAndSnapshotHash(address: bag.address)
            .then({ [unowned self] (latestAccountBlock, latestSnapshotHash) -> Promise<(latestAccountBlock: AccountBlock, latestSnapshotHash: String, nonce: String)> in
                return self.getPowNonce(address: bag.address, preHash: latestAccountBlock.hash, difficulty: difficulty).then({ nonce in
                    return Promise { seal in seal.fulfill((latestAccountBlock, latestSnapshotHash, nonce)) }
                })
            })
            .done ({ (latestAccountBlock, latestSnapshotHash, nonce) in
                let context = SendTransactionContext(latestAccountBlock: latestAccountBlock, bag: bag, latestSnapshotHash: latestSnapshotHash, toAddress: toAddress, tokenId: tokenId, amount: amount, data: data, nonce: nonce, difficulty: difficulty)
                completion(NetworkResult.success(context))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    func sendTransactionWithContext(_ context: SendTransactionContext,
                                    completion: @escaping (NetworkResult<Void>) -> Void) {

        let send = AccountBlock.makeSendAccountBlock(latest: context.latestAccountBlock,
                                                     bag: context.bag,
                                                     snapshotHash: context.latestSnapshotHash,
                                                     toAddress: context.toAddress,
                                                     tokenId: context.tokenId,
                                                     amount: context.amount,
                                                     data: context.data,
                                                     nonce: context.nonce,
                                                     difficulty: context.difficulty)
        createTransaction(accountBlock: send)
            .done ({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }
}

// MARK: Pledge
extension Provider {

    fileprivate enum ContractAddress: String {
        case pledgeAndGainQuota = "vite_000000000000000000000000000000000000000309508ba646"

        var address: Address {
            return Address(string: self.rawValue)
        }
    }

    fileprivate func getPledgeQuota(address: Address) -> Promise<(quota: String, maxTxCount: String)> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetPledgeQuotaRequest(address: address.description)))
            Session.send(request) { result in
                switch result {
                case .success((let quota, let maxTxCount)):
                    seal.fulfill((quota, maxTxCount))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    fileprivate func getPledges(address: Address, index: Int, count: Int) -> Promise<[Pledge]> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetPledgesRequest(address: address.description, index: index, count: count)))
            Session.send(request) { result in
                switch result {
                case .success(let pledges):
                    seal.fulfill(pledges)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }

    fileprivate func getPledgeData(beneficialAddress: Address) -> Promise<String> {
        return Promise { seal in
            let request = ViteServiceRequest(for: server, batch: BatchFactory().create(GetPledgeDataRequest(beneficialAddress: beneficialAddress.description)))
            Session.send(request) { result in
                switch result {
                case .success(let data):
                    seal.fulfill(data)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

extension Provider {

    func getPledgeQuota(address: Address, completion: @escaping (NetworkResult<(quota: String, maxTxCount: String)>) -> Void) {
        getPledgeQuota(address: address)
            .done ({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    func getPledges(address: Address, index: Int, count: Int, completion: @escaping (NetworkResult<[Pledge]>) -> Void) {
        getPledges(address: address, index: index, count: count)
            .done ({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    func pledgeAndGainQuotaWithoutGetPow(bag: HDWalletManager.Bag,
                                         beneficialAddress: Address,
                                         tokenId: String,
                                         amount: BigInt,
                                         completion: @escaping (NetworkResult<Void>) -> Void) {
        getPledgeData(beneficialAddress: beneficialAddress)
            .then({ [unowned self] (data) -> Promise<(latestAccountBlock: AccountBlock, latestSnapshotHash: String, data: String)> in
                return self.getLatestAccountBlockAndSnapshotHash(address: bag.address).then({ (latestAccountBlock, latestSnapshotHash) in
                    return Promise { seal in seal.fulfill((latestAccountBlock, latestSnapshotHash, data)) }
                })
            })
            .then({ [unowned self] (latestAccountBlock, latestSnapshotHash, data) -> Promise<Void> in
                let send = AccountBlock.makeSendAccountBlock(latest: latestAccountBlock,
                                                             bag: bag,
                                                             snapshotHash: latestSnapshotHash,
                                                             toAddress: ContractAddress.pledgeAndGainQuota.address,
                                                             tokenId: tokenId,
                                                             amount: amount,
                                                             data: data,
                                                             nonce: nil,
                                                             difficulty: nil)
                return self.createTransaction(accountBlock: send)
            })
            .done ({
                completion(NetworkResult.success($0))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }

    func pledgeAndGainQuotaWithGetPow(bag: HDWalletManager.Bag,
                                      beneficialAddress: Address,
                                      tokenId: String,
                                      amount: BigInt,
                                      difficulty: BigInt,
                                      completion: @escaping (NetworkResult<SendTransactionContext>) -> Void) {
        getPledgeData(beneficialAddress: beneficialAddress)
            .then({ [unowned self] (data) -> Promise<(latestAccountBlock: AccountBlock, latestSnapshotHash: String, data: String)> in
                return self.getLatestAccountBlockAndSnapshotHash(address: bag.address).then({ (latestAccountBlock, latestSnapshotHash) in
                    return Promise { seal in seal.fulfill((latestAccountBlock, latestSnapshotHash, data)) }
                })
            })
            .then({ [unowned self] (latestAccountBlock, latestSnapshotHash, data) -> Promise<(latestAccountBlock: AccountBlock, latestSnapshotHash: String, data: String, nonce: String)> in
                return self.getPowNonce(address: bag.address, preHash: latestAccountBlock.hash, difficulty: difficulty).then({ nonce in
                    return Promise { seal in seal.fulfill((latestAccountBlock, latestSnapshotHash, data, nonce)) }
                })
            })
            .done({ (latestAccountBlock, latestSnapshotHash, data, nonce) in
                let context = SendTransactionContext(latestAccountBlock: latestAccountBlock, bag: bag, latestSnapshotHash: latestSnapshotHash, toAddress: ContractAddress.pledgeAndGainQuota.address, tokenId: tokenId, amount: amount, data: data, nonce: nonce, difficulty: difficulty)
                completion(NetworkResult.success(context))
            })
            .catch({
                completion(NetworkResult.wrapError($0))
            })
    }
}
