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

    var hasChooseMnemonicWordsList =  BehaviorRelay<[String]>(value: [])
    var hasLeftMnemonicWordsList =  BehaviorRelay<[String]>(value: [])

    init(mnemonicWordsStr: String) {

        super.init()
        self.mnemonicWordsStr = mnemonicWordsStr
        self.mnemonicWordsList = mnemonicWordsStr.components(separatedBy: " ")
        self.hasLeftMnemonicWordsList.accept(mnemonicWordsStr.components(separatedBy: " "))
    }

    func selectedWord(isHasSelected: Bool, dataIndex: Int, word: String) {
        if isHasSelected {

            var list = self.hasChooseMnemonicWordsList.value
            list.remove(at: dataIndex)
            self.hasChooseMnemonicWordsList.accept(list)

            var list1 = self.hasLeftMnemonicWordsList.value
            list1.append(word)
            self.hasLeftMnemonicWordsList.accept(list1)
        } else {
            var list = self.hasChooseMnemonicWordsList.value
            list.append(word)
            self.hasChooseMnemonicWordsList.accept(list)

            var list1 = self.hasLeftMnemonicWordsList.value
            list1.remove(at: dataIndex)
            self.hasLeftMnemonicWordsList.accept(list1)
        }
    }
}
