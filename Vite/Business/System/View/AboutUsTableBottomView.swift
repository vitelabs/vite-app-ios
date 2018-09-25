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
                ["img": "icon_button_github", "web": "https://github.com/vitelabs"],
                ["img": "icon_button_twitter", "web": "https://twitter.com/vitelabs"],
                ["img": "icon_button_telegram", "web": "https://t.me/vite_en"],
                ["img": "icon_button_reddit", "web": "https://www.reddit.com/r/vitelabs"],
                ["img": "icon_button_wechat", "web": "https://mp.weixin.qq.com/mp/profile_ext?action=home&__biz=MzU0NDgxMjU0Ng==&scene=124#wechat_redirect"],
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
        self.officialWebsiteBtn.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(self).offset(padding)
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.width.equalTo(63)
            make.height.equalTo(20)
        }

        let paddingView = UIView()
        paddingView.backgroundColor = .clear
        self.addSubview(paddingView)
        paddingView.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(self.officialWebsiteBtn.snp.right)
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.height.equalTo(20)
        }

        self.addSubview(portalWebsiteBtn)
        self.portalWebsiteBtn.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(paddingView.snp.right)
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.width.equalTo(93)
            make.height.equalTo(20)
        }

        let paddingView1 = UIView()
        paddingView1.backgroundColor = .clear
        self.addSubview(paddingView1)
        paddingView1.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(self.portalWebsiteBtn.snp.right)
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.height.equalTo(20)
            make.width.equalTo(paddingView)
        }

        self.addSubview(blogWebsiteBtn)
        self.blogWebsiteBtn.snp.makeConstraints {  (make) -> Void in
            make.left.equalTo(paddingView1.snp.right)
            make.right.equalTo(self).offset(-padding)
            make.top.equalTo(collectionView.snp.bottom).offset(30)
            make.width.equalTo(63)
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
        officialWebsiteBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        officialWebsiteBtn.rx.tap.bind {_ in
            WebHandler.open(URL.init(string: "https://www.vite.org/")!)
        }.disposed(by: rx.disposeBag)
        return officialWebsiteBtn
    }()

    lazy var portalWebsiteBtn: UIButton = {
        let portalWebsiteBtn = UIButton.init(style: .whiteWithoutShadow, title: R.string.localizable.aboutUsPageCellPortalWebsite.key.localized())
        portalWebsiteBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        portalWebsiteBtn.rx.tap.bind {_ in
            WebHandler.open(URL.init(string: "https://vite.net/")!)
        }.disposed(by: rx.disposeBag)
        return portalWebsiteBtn
    }()

    lazy var blogWebsiteBtn: UIButton = {
        let blogWebsiteBtn = UIButton.init(style: .whiteWithoutShadow, title: R.string.localizable.aboutUsPageCellBlogWebsite.key.localized())
        blogWebsiteBtn.titleLabel?.adjustsFontSizeToFitWidth = true
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
        WebHandler.open(URL.init(string: dic["web"]!)!)
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
