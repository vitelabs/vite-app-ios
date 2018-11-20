//
//  IntroductionViewController.swift
//  Vite
//
//  Created by Water on 2018/11/20.
//  Copyright © 2018 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RazzleDazzle
import SCPageControl

class IntroductionViewController: AnimatedPagingScrollViewController {
    fileprivate let numPages = 4
    fileprivate var iconsDict: [String] = [
        "intro_icon_0",
        "intro_icon_1",
        "intro_icon_2",
        "intro_icon_3",
        ]
    fileprivate var tipsTitleDict: [String] = [
        R.string.localizable.introductionPageTip1Title(),
        R.string.localizable.introductionPageTip2Title(),
        R.string.localizable.introductionPageTip3Title(),
        R.string.localizable.introductionPageTip4Title(),
        ]
    fileprivate var tipsDescDict: [String] =  [
        R.string.localizable.introductionPageTip1Desc(),
        R.string.localizable.introductionPageTip2Desc(),
        R.string.localizable.introductionPageTip3Desc(),
        R.string.localizable.introductionPageTip4Desc(),
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self._setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    lazy var pageControlView: SCPageControlView = {
        let sc = SCPageControlView()
        return sc
    }()

    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton.init(style: .blue)
        nextBtn.setTitle(R.string.localizable.introductionPageNextBtnTitle(), for: .normal)
        nextBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        nextBtn.rx.tap.bind {

            UserDefaultsService.instance.setObject(true, forKey: "IntroView", inCollection: "ShowIntroViewPage")
            self.dismiss(animated: false, completion: nil)
        }.disposed(by: rx.disposeBag)
        return nextBtn
    }()

    override func numberOfPages() -> Int {
        return numPages
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)

        let nearestPage = Int(self.pageOffset + 0.5)

        if nearestPage == 3 {
            self.view.addSubview(self.nextBtn)
            self.nextBtn.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.left.equalTo(self.view).offset(24)
                make.right.equalTo(self.view).offset(-24)
                make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-24)
            }
            self.pageControlView.isHidden = true
        } else {
            self.nextBtn.removeFromSuperview()
            self.pageControlView.isHidden = false
        }
        self.pageControlView.scroll_did(scrollView)
    }
}
extension IntroductionViewController {
    private func _setupView() {
        self.view.backgroundColor = .white

        self.configureViews()

        pageControlView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height-70, width: UIScreen.main.bounds.size.width, height: 4)
        pageControlView.scp_style = .SCNormal
        pageControlView.set_view(numPages, current: 0, current_color: UIColor(netHex: 0x007AFF), disable_color: nil)
        view.addSubview(pageControlView)
    }

    private func configureViews() {
        var scaleFactor = CGFloat(1.0)
        let desginHeight = CGFloat(667)
        if is_iPhoneX {
            scaleFactor = kScreenH/desginHeight
        }

        for (index, item) in self.iconsDict.enumerated() {
            let iconImg = UIImage(named: item)
            if iconImg !=  nil {
//                iconImg = scaleFactor != 1.0 ? iconImg.scale
                let iconImgView = UIImageView(image: iconImg)
                self.contentView.addSubview(iconImgView)

                if index == 0 {
                    self.keepView(iconImgView, onPages: [CGFloat(index+1), CGFloat(index)], atTimes: [CGFloat(index-1), CGFloat(index)])
                } else {
                    self.keepView(iconImgView, onPage: CGFloat(index))
                }
                iconImgView.snp.makeConstraints { (make) in
                    make.top.equalTo(contentView).offset(-50)
                }

                let iconAlphaAnimation = AlphaAnimation(view: iconImgView)
                iconAlphaAnimation.addKeyframe(CGFloat(index) - 0.5, value: 0.0)
                iconAlphaAnimation.addKeyframe(CGFloat(index), value: 1.0)
                iconAlphaAnimation.addKeyframe(CGFloat(index) + 0.5, value: 0.0)
                self.animator.addAnimation(iconAlphaAnimation)

                let tipsTitleLab = UILabel()
                tipsTitleLab.font = Fonts.Font24
                tipsTitleLab.textColor = UIColor(netHex: 0x007AFF)
                tipsTitleLab.textAlignment = .center
                tipsTitleLab.text = self.tipsTitleDict[index]
                self.contentView.addSubview(tipsTitleLab)

               self.keepView(tipsTitleLab, onPages: [CGFloat(index+1), CGFloat(index), CGFloat(index-1)], atTimes: [CGFloat(index-1), CGFloat(index), CGFloat(index+1)])

                let tipsTitleLabAlphaAnimation = AlphaAnimation(view: iconImgView)
                tipsTitleLabAlphaAnimation.addKeyframe(CGFloat(index) - 0.5, value: 0.0)
                tipsTitleLabAlphaAnimation.addKeyframe(CGFloat(index), value: 1.0)
                tipsTitleLabAlphaAnimation.addKeyframe(CGFloat(index) + 0.5, value: 0.0)
                self.animator.addAnimation(tipsTitleLabAlphaAnimation)

                tipsTitleLab.snp.makeConstraints { (make) in
                    make.top.equalTo(iconImgView.snp.bottom).offset(20)
                    make.width.equalTo(contentView).offset(-48)
                }

                let tipsDescLab = UILabel()
                tipsDescLab.font = Fonts.Font14
                tipsDescLab.textColor = Colors.titleGray
                tipsDescLab.textAlignment = .center
                tipsDescLab.text = self.tipsDescDict[index]
                self.contentView.addSubview(tipsDescLab)

                self.keepView(tipsDescLab, onPages: [CGFloat(index+1), CGFloat(index), CGFloat(index-1)], atTimes: [CGFloat(index-1), CGFloat(index), CGFloat(index+1)])

                let tipsDescLabAlphaAnimation = AlphaAnimation(view: iconImgView)
                tipsDescLabAlphaAnimation.addKeyframe(CGFloat(index) - 0.5, value: 0.0)
                tipsDescLabAlphaAnimation.addKeyframe(CGFloat(index), value: 1.0)
                tipsDescLabAlphaAnimation.addKeyframe(CGFloat(index) + 0.5, value: 0.0)
                self.animator.addAnimation(tipsDescLabAlphaAnimation)

                tipsDescLab.snp.makeConstraints { (make) in
                    make.top.equalTo(tipsTitleLab.snp.bottom).offset(20)
                    make.width.equalTo(contentView).offset(-48)
                }

            }
        }
    }
}
