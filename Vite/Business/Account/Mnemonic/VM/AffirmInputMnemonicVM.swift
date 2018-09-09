//
//  AffirmInputMnemonicVM.swift
//  Vite
//
//  Created by Water on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Vite_keystore

final class AffirmInputMnemonicVM: NSObject {
    var mnemonicWordsStr: String?
    var mnemonicWordsList: [String]?

    var hasChooseMnemonicWordsList =  Variable<[String]>([])
    var hasLeftMnemonicWordsList =  Variable<[String]>([])

    init(mnemonicWordsStr: String) {

        super.init()
        self.mnemonicWordsStr = mnemonicWordsStr
        self.mnemonicWordsList = mnemonicWordsStr.components(separatedBy: " ")
        self.hasLeftMnemonicWordsList.value = mnemonicWordsStr.components(separatedBy: " ")
    }

    func selectedWord(isHasSelected: Bool, dataIndex: Int, word: String) {
        if isHasSelected {
            self.hasChooseMnemonicWordsList.value.remove(at: dataIndex)
            self.hasLeftMnemonicWordsList.value.append(word)
        } else {
            self.hasChooseMnemonicWordsList.value.append(word)
            self.hasLeftMnemonicWordsList.value.remove(at: dataIndex)
        }
    }
}
