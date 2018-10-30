//
//  AboutUsTableBottomView.swift
//  Vite
//
//  Created by Water on 2018/9/17.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import ReusableKit

private enum Reusable {
    static let aboutUsCollectionViewCell = ReusableCell<AboutUsCollectionViewCell>()
}

class AboutUsTableBottomView: UIView {
    let padding = CGFloat(24.0)
    let w_num = CGFloat(4.0)
    let h_num = CGFloat(2.0)

    var dataList: [[String: String]]
    override init(frame: CGRect) {
        self.dataList =
             [
                ["img": "icon_button_github", "web": "https://github.com/vitelabs/vite-app-ios"],
                ["img": "icon_button_twitter", "web": "https://twitter.com/vitelabs"],
                ["img": "icon_button_telegram", "web": "https://t.me/vite_en"],
                ["img": "icon_button_reddit", "web": "https://www.reddit.com/r/vitelabs"],
                ["img": "icon_button_facebook", "web": "https://www.facebook.com/vitelabs/"],
                ["img": "icon_button_medium", "web": "https://discordapp.com/invite/CsVY76q"],
                ["img": "icon_button_youtube", "web": "https://www.youtube.com/channel/UC8qft2rEzBnP9yJOGdsJBVg"],
                ]
        super.init(frame: frame)

        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(Reusable.aboutUsCollectionViewCell)
        self.collectionView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(32)
            make.left.right.equalTo(self)
            make.height.equalTo(120)
        }

        self.addSubview(self.officialWebsiteBtn)
        self.officialWebsiteBtn.snp.remakeConstraints {  (make) -> Void in
            make.left.equalTo(self).offset(padding)
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.height.equalTo(20)
        }

        self.addSubview(portalWebsiteBtn)
        self.portalWebsiteBtn.snp.remakeConstraints {  (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.height.equalTo(20)
        }

        self.addSubview(blogWebsiteBtn)
        self.blogWebsiteBtn.snp.remakeConstraints {  (make) -> Void in
            make.right.equalTo(self).offset(-padding)
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.height.equalTo(20)
        }
    }

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        return collectionView
    }()

    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.minimumInteritemSpacing = (kScreenW-padding*2 - 50*w_num)/(w_num)
        return collectionViewLayout
    }()

    lazy var officialWebsiteBtn: UIButton = {
        let officialWebsiteBtn = UIButton.init(style: .whiteWithoutShadow, title: R.string.localizable.aboutUsPageCellOfficialWebsite.key.localized())
        officialWebsiteBtn.titleLabel?.adjustsFontSizeToFitWidth = false
        officialWebsiteBtn.rx.tap.bind {_ in
            WebHandler.open(URL.init(string: "https://www.vite.org/")!)
        }.disposed(by: rx.disposeBag)
        return officialWebsiteBtn
    }()

    lazy var portalWebsiteBtn: UIButton = {
        let portalWebsiteBtn = UIButton.init(style: .whiteWithoutShadow, title: R.string.localizable.aboutUsPageCellPortalWebsite.key.localized())
        portalWebsiteBtn.titleLabel?.adjustsFontSizeToFitWidth = false
        portalWebsiteBtn.rx.tap.bind {_ in
            WebHandler.open(URL.init(string: "https://vite.net/")!)
        }.disposed(by: rx.disposeBag)
        return portalWebsiteBtn
    }()

    lazy var blogWebsiteBtn: UIButton = {
        let blogWebsiteBtn = UIButton.init(style: .whiteWithoutShadow, title: R.string.localizable.aboutUsPageCellBlogWebsite.key.localized())
        blogWebsiteBtn.titleLabel?.adjustsFontSizeToFitWidth = false
        blogWebsiteBtn.rx.tap.bind {_ in
            WebHandler.open(URL.init(string: "https://vite.blog/")!)
        }.disposed(by: rx.disposeBag)
        return blogWebsiteBtn
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AboutUsTableBottomView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(Reusable.aboutUsCollectionViewCell, for: indexPath)
        let dic = dataList[indexPath.row]
        cell.iconImgView.image = UIImage.init(named: dic["img"]!)
        return cell
    }

}

extension AboutUsTableBottomView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dic = dataList[indexPath.row]
        let url = URL.init(string: dic["web"]!)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

final class AboutUsCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var iconImgView: UIImageView = {
        let iconImgView = UIImageView()
        return iconImgView
    }()

    func initView() {
        self.addSubview(iconImgView)
        self.iconImgView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
            make.width.height.equalTo(50)
        }
    }
}
