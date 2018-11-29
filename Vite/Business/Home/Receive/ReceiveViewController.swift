//
//  ReceiveViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/10.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import BigInt

class ReceiveViewController: BaseViewController {

    enum Style {
        case `default`
        case token
    }

    let token: Token
    let wallet: HDWalletStorage.Wallet
    let bag: HDWalletManager.Bag
    let style: Style

    let amountBehaviorRelay: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let uriBehaviorRelay: BehaviorRelay<ViteURI>

    init(token: Token, style: Style) {
        self.token = token
        // FIXME: Optional
        self.wallet = HDWalletManager.instance.wallet!
        self.bag = HDWalletManager.instance.bag!
        self.style = style
        self.uriBehaviorRelay = BehaviorRelay(value: ViteURI.transfer(address: bag.address, tokenId: token.id, amountString: nil, decimalsString: nil, data: nil))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        kas_activateAutoScrollingForView(scrollView.stackView)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // View
    let whiteView = UIImageView(image: R.image.background_button_white()?.resizable).then {
        $0.layer.shadowColor = UIColor(netHex: 0x000000).cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 5)
        $0.layer.shadowRadius = 20
    }

    lazy var scrollView = ScrollableView(insets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)).then {
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    lazy var headerView = ReceiveHeaderView(name: self.wallet.name, address: bag.address.description)
    let middleView = ReceiveMiddleView()
    let qrcodeView = ReceiveQRCodeView()
    let footerView = ReceiveFooterView()

    func setupView() {

        navigationBarStyle = .clear
        navigationItem.title = .token == style ? R.string.localizable.receivePageTokenTitle() : R.string.localizable.receivePageMineTitle()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.icon_nav_share_black(), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(onShare))
        view.backgroundColor = UIColor.gradientColor(style: .top2bottom, frame: view.frame, colors: token.backgroundColors)

        view.addSubview(whiteView)
        view.addSubview(scrollView)

        whiteView.snp.makeConstraints { (m) in
            m.edges.equalTo(scrollView)
        }

        scrollView.snp.makeConstraints { (m) in
            m.top.greaterThanOrEqualTo(view.safeAreaLayoutGuideSnpTop).offset(6)
            m.centerY.equalTo(view).priority(.medium)
            m.left.equalTo(view).offset(24)
            m.right.equalTo(view).offset(-24)
            m.bottom.lessThanOrEqualTo(view).offset(-24)
        }

        scrollView.stackView.addArrangedSubview(headerView)

        switch style {
        case .default:
            scrollView.stackView.addArrangedSubview(qrcodeView)
            scrollView.stackView.addPlaceholder(height: 10)
        case .token:
            scrollView.stackView.addArrangedSubview(middleView)
            scrollView.stackView.addArrangedSubview(qrcodeView)
            scrollView.stackView.addArrangedSubview(footerView)

            footerView.amountButton.rx.tap
                .bind {
                    Alert.show(into: self,
                               title: R.string.localizable.receivePageTokenAmountAlertTitle(),
                               message: nil,
                               actions: [(.cancel, nil),
                                         (.default(title: R.string.localizable.confirm()), {[weak self] alertController in
                                            guard let textField = alertController.textFields?.first else { fatalError() }
                                            self?.amountBehaviorRelay.accept(textField.text)
                                         }),
                                         ], config: { alertController in
                                            alertController.addTextField(configurationHandler: { [weak self] in
                                                $0.keyboardType = .decimalPad
                                                $0.text = self?.amountBehaviorRelay.value
                                                $0.delegate = self
                                            })
                    })
                }.disposed(by: rx.disposeBag)

            amountBehaviorRelay.asDriver()
                .map { [weak self] in
                    guard let `self` = self else { return "" }
                    if let amount = $0 {
                        return "\(amount) \(self.token.symbol)"
                    } else {
                        return R.string.localizable.receivePageTokenNameLabel(self.token.symbol)
                    }
                }
                .drive(middleView.tokenSymbolLabel.rx.text).disposed(by: rx.disposeBag)

            Observable.combineLatest(amountBehaviorRelay.asObservable(), footerView.noteTitleTextFieldView.textField.rx.text.asObservable())
                .map {
                    ViteURI.transfer(address: self.bag.address, tokenId: self.token.id, amountString: $0, decimalsString: "\(self.token.decimals)", data: $1)
                }
                .bind(to: uriBehaviorRelay).disposed(by: rx.disposeBag)
        }

        uriBehaviorRelay.asObservable()
            .map {
                $0.string()
            }
            .bind {
                QRCodeHelper.createQRCode(string: $0) { [weak self] image in
                    self?.qrcodeView.imageView.image = image
                }
            }
            .disposed(by: rx.disposeBag)
    }

    @objc func onShare() {

        let superView = UIView()
        let backView = UIView()
        let contentView = UIImageView(image: R.image.background_button_white()?.resizable).then {
            $0.layer.shadowColor = UIColor(netHex: 0x000000).cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 5)
            $0.layer.shadowRadius = 20
        }

        superView.addSubview(backView)
        backView.snp.makeConstraints { (m) in
            m.center.equalTo(superView)
            m.width.equalTo(375)
        }

        backView.addSubview(contentView)
        contentView.snp.makeConstraints { (m) in
            m.top.equalTo(backView).offset(70)
            m.left.equalTo(backView).offset(24)
            m.right.equalTo(backView).offset(-24)
            m.bottom.equalTo(backView).offset(-70)
        }

        let headerView = ReceiveShareHeaderView(name: self.wallet.name, address: bag.address.description)
        let middleView = ReceiveMiddleView()
        let qrcodeView = UIImageView(image: self.qrcodeView.imageView.screenshot)
        let footerView = ReceiveShareFooterView(text: self.footerView.noteTitleTextFieldView.textField.text)

        middleView.tokenSymbolLabel.text = self.middleView.tokenSymbolLabel.text

        contentView.addSubview(headerView)
        contentView.addSubview(qrcodeView)

        headerView.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(contentView)
        }

        switch style {
        case .default:
            qrcodeView.snp.makeConstraints { (m) in
                m.top.equalTo(headerView.snp.bottom).offset(20)
                m.centerX.equalTo(contentView)
                m.size.equalTo(CGSize(width: 170, height: 170))
                m.bottom.equalTo(contentView).offset(-30)
            }
        case .token:
            contentView.addSubview(middleView)
            contentView.addSubview(footerView)

            middleView.snp.makeConstraints { (m) in
                m.top.equalTo(headerView.snp.bottom)
                m.left.right.equalTo(contentView)
            }

            qrcodeView.snp.makeConstraints { (m) in
                m.top.equalTo(middleView.snp.bottom).offset(20)
                m.centerX.equalTo(contentView)
                m.size.equalTo(CGSize(width: 170, height: 170))
            }

            footerView.snp.makeConstraints { (m) in
                m.top.equalTo(qrcodeView.snp.bottom).offset(20)
                m.left.right.bottom.equalTo(contentView)
            }
        }

        superView.setNeedsLayout()
        superView.layoutIfNeeded()
        backView.backgroundColor = UIColor.gradientColor(style: .top2bottom, frame: view.frame, colors: token.backgroundColors)
        guard let image = backView.screenshot else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}

extension ReceiveViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let (ret, text) = InputLimitsHelper.allowDecimalPointWithDigitalText(textField.text ?? "", shouldChangeCharactersIn: range, replacementString: string, decimals: min(8, token.decimals))
        textField.text = text
        return ret
    }
}
