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

    var chooseMnemonicWordsList =  Variable<[String]>([])
    var leftMnemonicWordsList =  Variable<[String]>([])

    init(mnemonicWordsStr: String) {

        super.init()
        self.mnemonicWordsStr = mnemonicWordsStr
        self.mnemonicWordsList = mnemonicWordsStr.components(separatedBy: " ")
        self.chooseMnemonicWordsList.value = mnemonicWordsStr.components(separatedBy: " ")
        self.leftMnemonicWordsList.value = mnemonicWordsStr.components(separatedBy: " ")
    }
}

extension AffirmInputMnemonicVM {
    typealias input = AffirmInputMnemonicInput
    typealias output = AffirmInputMnemonicOutput

    struct AffirmInputMnemonicInput {
        var isChoose : Bool
        var chooseWord : String
    }

    struct AffirmInputMnemonicOutput {


    }

}


