//
//  BackupMnemonicVM.swift
//  Vite
//
//  Created by Water on 2018/9/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Vite_keystore

final class BackupMnemonicVM: NSObject {
    var mnemonicWordsStr  =  Variable(Mnemonic.randomGenerator(strength: .strong, language: .english))

    override init() {
        super.init()
    }

    func fetchNewMnemonicWords() {
        self.mnemonicWordsStr.value = Mnemonic.randomGenerator(strength: .strong, language: .english)
    }
}
