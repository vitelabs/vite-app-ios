//
//  BackupMnemonicVM.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Vite_keystore

final class BackupMnemonicVM: NSObject {
    var mnemonicWordsStr  =  BehaviorRelay(value: Mnemonic.randomGenerator(strength: .strong, language: .english))

    var mnemonicWordsList =  BehaviorRelay<[String]>(value: [])

    override init() {
        super.init()
        mnemonicWordsList.accept(mnemonicWordsStr.value.components(separatedBy: " "))
    }

    func fetchNewMnemonicWords() {
        self.mnemonicWordsStr.accept(Mnemonic.randomGenerator(strength: .strong, language: .english))
        self.mnemonicWordsList.accept(mnemonicWordsStr.value.components(separatedBy: " "))
    }
}
