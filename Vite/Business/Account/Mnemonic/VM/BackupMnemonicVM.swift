//
//  BackupMnemonicVM.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import Action
import RxCocoa
import RxSwift
import Vite_HDWalletKit

final class BackupMnemonicVM: NSObject {
    var mnemonicWordsStr  =  BehaviorRelay(value: Mnemonic.randomGenerator(strength: .strong, language: .english))

    var mnemonicWordsList =  BehaviorRelay<[String]>(value: [])

    var fetchNewMnemonicWordsAction: Action<Void, Void>?

    var switchModeMnemonicWordsAction: Action<Void, Void>?

    private var mnemonicStrength: Mnemonic.Strength = .strong

    override init() {
        super.init()
        mnemonicWordsList.accept(mnemonicWordsStr.value.components(separatedBy: " "))

        fetchNewMnemonicWordsAction = Action {
            self.mnemonicWordsStr.accept(Mnemonic.randomGenerator(strength: self.mnemonicStrength, language: .english))
            self.mnemonicWordsList.accept(self.mnemonicWordsStr.value.components(separatedBy: " "))
            return Observable.empty()
        }

        switchModeMnemonicWordsAction = Action {
            if self.mnemonicStrength == .strong {
                self.mnemonicStrength = .weak
            } else if self.mnemonicStrength == .weak {
                self.mnemonicStrength = .strong
            }
            self.mnemonicWordsStr.accept(Mnemonic.randomGenerator(strength: self.mnemonicStrength, language: .english))
            self.mnemonicWordsList.accept(self.mnemonicWordsStr.value.components(separatedBy: " "))
            return Observable.empty()
        }
    }
}
