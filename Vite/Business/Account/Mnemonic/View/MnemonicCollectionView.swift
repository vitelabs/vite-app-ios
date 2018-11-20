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

private enum Reusable {
    static let wordCollectionViewCell = ReusableCell<WordCollectionViewCell>()
}

protocol MnemonicCollectionViewDelegate: class {
    func chooseWord(isHasSelected: Bool, dataIndex: Int, word: String)
}

final class MnemonicCollectionView: UIView {
    private var isHasSelected = false
    weak var delegate: MnemonicCollectionViewDelegate?
    private let padding = CGFloat(6.0)
    private let w_num = CGFloat(4.0)
    var h_num = CGFloat(6.0)

    var dataList: [String] = [] {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.collectionView.reloadData()
            }
        }
    }

    init(isHasSelected: Bool) {
        super.init(frame: .zero)

        self.isHasSelected = isHasSelected
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Colors.bgGray
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

    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        let h = self.frame.size.height

        let itemWidth = (w-(padding * (w_num+1)))/w_num
        let itemHeight = (h-(padding * (h_num+1)))/h_num
        collectionViewLayout.itemSize = CGSize.init(width: itemWidth, height: itemHeight)

        collectionView.reloadData()
    }

    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = padding
        collectionViewLayout.minimumInteritemSpacing = padding
        return collectionViewLayout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.chooseWord(isHasSelected: isHasSelected, dataIndex: indexPath.row, word: dataList[indexPath.row])
    }
}
