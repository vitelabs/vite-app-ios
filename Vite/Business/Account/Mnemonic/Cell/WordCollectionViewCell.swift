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
        wordLabel.font = Fonts.Font12
        wordLabel.textColor = Colors.descGray
        wordLabel.adjustsFontSizeToFitWidth = true
        return wordLabel
    }()

    func initView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true

        self.addSubview(wordLabel)
        self.wordLabel.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
    }
}
