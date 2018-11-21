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
import Vite_HDWalletKit

final class AffirmInputMnemonicVM: NSObject {
    let mnemonicWordsList: [String]

    var hasChooseMnemonicWordsList =  BehaviorRelay<[String]>(value: [])
    var hasLeftMnemonicWordsList =  BehaviorRelay<[String]>(value: [])

    init(mnemonicWordsStr: String) {
        let array = mnemonicWordsStr.components(separatedBy: " ")
        let sortedList  = array.sorted {(s1, s2) -> Bool in
             return s2  > s1
        }
        self.mnemonicWordsList = sortedList
        self.hasLeftMnemonicWordsList.accept(self.mnemonicWordsList)

        #if DEBUG
        self.hasChooseMnemonicWordsList.accept(array)
        self.hasLeftMnemonicWordsList.accept([])
        UIPasteboard.general.string = mnemonicWordsStr
        #endif
        super.init()
    }

    func selectedWord(isHasSelected: Bool, dataIndex: Int, word: String) {
        var list = self.hasChooseMnemonicWordsList.value
        if isHasSelected {
            list.removeSubrange(dataIndex ..< list.count)
        } else {
            list.append(word)
        }
        self.hasChooseMnemonicWordsList.accept(list)
        let leftList = self.mnemonicWordsList.filter {
            !list.contains($0)
        }
        self.hasLeftMnemonicWordsList.accept(leftList)
    }
}
