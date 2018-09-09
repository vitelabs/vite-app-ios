//
//  WordCollectionViewCell.swift
//  Vite
//
//  Created by Water on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit

final class WordCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var wordLabel: UILabel = {
        let wordLabel = UILabel()
        wordLabel.textAlignment = .center
        wordLabel.backgroundColor = .clear
        wordLabel.layer.borderColor = UIColor(hex: "C6C6C6").cgColor
        wordLabel.layer.borderWidth = 0.5
        wordLabel.layer.cornerRadius = 4
        return wordLabel
    }()

    func initView() {
        self.addSubview(wordLabel)
        self.wordLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
    }
}
