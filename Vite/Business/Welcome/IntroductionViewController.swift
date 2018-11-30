//
//  IntroductionViewController.swift
//  Vite
//
//  Created by Water on 2018/11/20.
//  Copyright © 2018 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import NYXImagesKit
import RazzleDazzle
import CHIPageControl

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

    lazy var pageControlView: CHIPageControlAleppo = {
        let pageControl = CHIPageControlAleppo(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
        pageControl.numberOfPages = numPages
        pageControl.radius = 4
        pageControl.tintColor = UIColor(netHex: 0x007AFF)
        pageControl.currentPageTintColor = UIColor(netHex: 0x007AFF)
        pageControl.padding = 8
        return pageControl
    }()

    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton.init(style: .blue)
        nextBtn.setTitle(R.string.localizable.introductionPageNextBtnTitle(), for: .normal)
        nextBtn.titleLabel?.adjustsFontSizeToFitWidth  = true
        nextBtn.rx.tap.bind {
            UserDefaultsService.instance.setObject(Constants.IntroductionPageVersion, forKey: "IntroView", inCollection: "IntroViewPageVersion")
            NotificationCenter.default.post(name: .finishShowIntroPage, object: nil)
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
            self.nextBtn.isHidden = false
        } else {
             self.nextBtn.isHidden = true
        }
        self.pageControlView.set(progress: nearestPage, animated: true)
    }
}
extension IntroductionViewController {
    private func _setupView() {
        self.view.backgroundColor = .white
        self.configureViews()

        self.view.addSubview(self.nextBtn)
        self.nextBtn.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(24)
            make.right.equalTo(self.view).offset(-24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuideSnpBottom).offset(-24)
        }
        self.nextBtn.isHidden = true

        view.addSubview(pageControlView)
        pageControlView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(10)
            make.bottom.equalTo(self.nextBtn.snp.top).offset(-15)
            make.centerX.equalTo(self.view)
        }
    }

    private func createLab(_ font: UIFont, _ textColor: UIColor) -> UILabel {
        let tipsTitleLab = UILabel()
        tipsTitleLab.font = font
        tipsTitleLab.textColor = textColor
        tipsTitleLab.textAlignment = .center
        return tipsTitleLab
    }

    private func createAlphaAnimation(_ view: UIView, _ index: Int) -> AlphaAnimation {
        let tipsDescLabAlphaAnimation = AlphaAnimation(view: view)
        tipsDescLabAlphaAnimation.addKeyframe(CGFloat(index) - 0.5, value: 0.0)
        tipsDescLabAlphaAnimation.addKeyframe(CGFloat(index), value: 1.0)
        tipsDescLabAlphaAnimation.addKeyframe(CGFloat(index) + 0.5, value: 0.0)
        return tipsDescLabAlphaAnimation
    }

    private func configureViews() {
        var scaleFactor = Float(1.0)
        let desginHeight = CGFloat(667)
        if !UIDevice.current.isIPhoneX() && !UIDevice.current.isIPhone6() && !UIDevice.current.isIPhone6Plus() {
            scaleFactor = Float(kScreenH/desginHeight)
            let divisor = Int(scaleFactor*10)
            scaleFactor = Float(Float(divisor)/10.0)
        }
        for (index, item) in self.iconsDict.enumerated() {
            var iconImg = UIImage(named: item)
            if iconImg !=  nil {
                iconImg = scaleFactor != 1.0 ? iconImg?.scale(byFactor: scaleFactor) : iconImg
                let iconImgView = UIImageView(image: iconImg)
                self.contentView.addSubview(iconImgView)

                if index == 0 {
                    self.keepView(iconImgView, onPages: [CGFloat(index+1), CGFloat(index)], atTimes: [CGFloat(index-1), CGFloat(index)])
                } else {
                    self.keepView(iconImgView, onPage: CGFloat(index))
                }
                iconImgView.snp.makeConstraints { (make) in
                    make.top.equalTo(contentView)
                }

                let iconAlphaAnimation = self.createAlphaAnimation(iconImgView, index)
                self.animator.addAnimation(iconAlphaAnimation)

                let tipsTitleLab = self.createLab(Fonts.Font24, UIColor(netHex: 0x007AFF))
                tipsTitleLab.text = self.tipsTitleDict[index]
                self.contentView.addSubview(tipsTitleLab)

               self.keepView(tipsTitleLab, onPages: [CGFloat(index+1), CGFloat(index), CGFloat(index-1)], atTimes: [CGFloat(index-1), CGFloat(index), CGFloat(index+1)])

                let tipsTitleLabAlphaAnimation = self.createAlphaAnimation(tipsTitleLab, index)
                self.animator.addAnimation(tipsTitleLabAlphaAnimation)

                tipsTitleLab.snp.makeConstraints { (make) in
                    make.top.equalTo(iconImgView.snp.bottom).offset(50*Float(kScreenH/desginHeight))
                    make.width.equalTo(contentView).offset(-48)
                }

                let tipsDescLab = self.createLab(Fonts.Font14, Colors.titleGray)
                tipsDescLab.numberOfLines = 2
                let paragraph = NSMutableParagraphStyle()
                paragraph.lineSpacing = 5
                paragraph.alignment = .center
                let attributes = [NSAttributedString.Key.font: Fonts.Font14,
                                  NSAttributedString.Key.foregroundColor: Colors.titleGray,
                                  NSAttributedString.Key.paragraphStyle: paragraph ]
                tipsDescLab.attributedText = NSAttributedString(string: self.tipsDescDict[index], attributes: attributes)
                self.contentView.addSubview(tipsDescLab)

                self.keepView(tipsDescLab, onPages: [CGFloat(index+1), CGFloat(index), CGFloat(index-1)], atTimes: [CGFloat(index-1), CGFloat(index), CGFloat(index+1)])

                let tipsDescLabAlphaAnimation = self.createAlphaAnimation(tipsDescLab, index)
                self.animator.addAnimation(tipsDescLabAlphaAnimation)

                tipsDescLab.snp.makeConstraints { (make) in
                    make.top.equalTo(tipsTitleLab.snp.bottom).offset(6)
                    make.width.equalTo(self.view).offset(-48)
                }
            }
        }
    }
}
