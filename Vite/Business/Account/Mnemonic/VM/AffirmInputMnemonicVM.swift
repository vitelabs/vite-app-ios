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
    var mnemonicWordsStr: String?
    var mnemonicWordsList: [String]?

    var hasChooseMnemonicWordsList =  BehaviorRelay<[String]>(value: [])
    var hasLeftMnemonicWordsList =  BehaviorRelay<[String]>(value: [])

    init(mnemonicWordsStr: String) {

        super.init()
        self.mnemonicWordsStr = mnemonicWordsStr
        self.mnemonicWordsList = mnemonicWordsStr.components(separatedBy: " ")
        self.hasLeftMnemonicWordsList.accept(self.mnemonicWordsList?.shuffled() ?? [])
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

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
