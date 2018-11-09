//
//  MyHomeListCell.swift
//  Vite
//
//  Created by Stone on 2018/11/6.
//  Copyright © 2018 vite labs. All rights reserved.
//

import UIKit

class MyHomeListCell: BaseTableViewCell {

    static var cellHeight: CGFloat {
        return 60
    }

    fileprivate let titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        titleLab.textAlignment = .left
        titleLab.textColor = Colors.cellTitleGray
        titleLab.font = Fonts.light16
        return titleLab
    }()

    fileprivate let rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.backgroundColor = .clear
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.contentMode = .scaleAspectFit
        return rightImageView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let separatorLine = UIView().then {
            $0.backgroundColor = Colors.lineGray
        }

        contentView.addSubview(titleLab)
        contentView.addSubview(rightImageView)
        contentView.addSubview(separatorLine)

        titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(24)
            make.centerY.equalTo(contentView)
        }

        rightImageView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.right).offset(10)
            make.right.equalTo(contentView).offset(-20)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }

        separatorLine.snp.makeConstraints { (m) in
            m.height.equalTo(CGFloat.singleLineWidth)
            m.left.equalTo(titleLab)
            m.right.equalTo(rightImageView)
            m.bottom.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(viewModel: MyHomeListCellViewModel) {
        titleLab.text = viewModel.name.string
        viewModel.image?.putIn(rightImageView)
    }
}
