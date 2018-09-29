//
//  FetchWelfareViewController.swift
//  Vite
//
//  Created by Water on 2018/9/17.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import Then
import UIKit
import SnapKit
import Vite_HDWalletKit

class FetchWelfareViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self._setupView()
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    lazy var confirmBtn: UIButton = {
        let confirmBtn = UIButton.init(style: .blue)
        confirmBtn.setTitle(R.string.localizable.submit.key.localized(), for: .normal)
        confirmBtn.addTarget(self, action: #selector(confirmBtnAction), for: .touchUpInside)
        return confirmBtn
    }()

    lazy var addressTF: TitleTextView = {
        let addressTF = TitleTextView(title: R.string.localizable.fetchWelfareInputEthereumAddressTitle.key.localized(), text: "")
        addressTF.titleLabel.textColor = Colors.titleGray
        addressTF.titleLabel.font = AppStyle.formHeader.font
        addressTF.textView.font = AppStyle.inputDescWord.font
        addressTF.textView.textColor = Colors.descGray
        return addressTF
    }()
}

extension FetchWelfareViewController {

    private func _setupView() {
        self.view.backgroundColor = .white
        kas_activateAutoScrollingForView(view)
        navigationTitleView = NavigationTitleView(title: R.string.localizable.fetchWelfarePageTitle.key.localized())

        self._addViewConstraint()
    }
    private func _addViewConstraint() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo((self.navigationTitleView?.snp.bottom)!).offset(10)
        }

        let contentView = UIView()
        self.scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
        }

        let fetchWelfareCardView = FetchWelfareCardView().then {
            $0.backgroundColor = .clear
        }
        contentView.addSubview(fetchWelfareCardView)
        fetchWelfareCardView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.height.equalTo(171)
            make.top.equalTo(contentView).offset(10)
        }

        let wayTitleLab = UILabel().then {
            $0.backgroundColor = .clear
            $0.font = Fonts.Font14_b
            $0.textColor = Colors.titleGray
            $0.text = R.string.localizable.fetchWelfareParticipationTitle.key.localized()
        }
        contentView.addSubview(wayTitleLab)
        wayTitleLab.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(22)
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.top.equalTo(fetchWelfareCardView.snp.bottom).offset(20)
        }

        let wayContentLab = UILabel().then {
            $0.backgroundColor = .clear
            $0.numberOfLines = 0
        }
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        let attributes = [NSAttributedStringKey.font: Fonts.Font14,
                          NSAttributedStringKey.foregroundColor: Colors.titleGray,
                          NSAttributedStringKey.paragraphStyle: paragraph, ]
        wayContentLab.attributedText = NSAttributedString(string: R.string.localizable.fetchWelfareParticipationWays.key.localized(), attributes: attributes)

        contentView.addSubview(wayContentLab)
        wayContentLab.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.top.equalTo(wayTitleLab.snp.bottom)
        }

        contentView.addSubview(self.addressTF)
        self.addressTF.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(70)
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.top.equalTo(wayContentLab.snp.bottom).offset(20)
        }

        contentView.addSubview(self.confirmBtn)
        self.confirmBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
            make.top.equalTo(addressTF.snp.bottom).offset(50)
            make.bottom.equalToSuperview().offset(-50)
        }
    }

    @objc func confirmBtnAction() {

        let address = self.addressTF.textView.text ?? ""

        if  EthereumAddress.isValid(string: address) {
            //TODO:::  go send
            let sendViewController = SendViewController(tokenId: "", address: nil, amount: nil, note: nil)
            self.navigationController?.pushViewController(sendViewController, animated: true)
        } else {
            self.displayConfirmAlter(title: R.string.localizable.fetchWelfareInputEthereumAddressErrorTitle.key.localized(), done: R.string.localizable.confirm.key.localized(), doneHandler: {
            })
        }
    }
}
