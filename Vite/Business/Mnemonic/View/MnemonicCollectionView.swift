//
//  MnemonicCollectionView.swift
//  Vite
//
//  Created by Water on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ReusableKit

final class MnemonicCollectionView: UIView {

    var dataList: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(Reusable.wordCollectionViewCell)
        self.collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
}

extension MnemonicCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(Reusable.wordCollectionViewCell, for: indexPath)
        cell.wordLabel.text = dataList[indexPath.row]
        return cell
    }
}

extension MnemonicCollectionView: UICollectionViewDelegate {

}

fileprivate enum Reusable {
    static let wordCollectionViewCell = ReusableCell<WordCollectionViewCell>()
}
