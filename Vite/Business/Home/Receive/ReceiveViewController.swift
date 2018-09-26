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
import ChameleonFramework
import BigInt

class ReceiveViewController: BaseViewController {

    enum Style {
        case `default`
        case token
    }

    let bag = HDWalletManager.instance.bag()
    let token: Token
    let style: Style

    let amountBehaviorRelay: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let uriBehaviorRelay: BehaviorRelay<ViteURI>

    init(token: Token, style: Style) {
        self.token = token
        self.style = style
        self.uriBehaviorRelay = BehaviorRelay(value: ViteURI.transfer(address: bag.address, tokenId: token.id, amount: nil, data: nil))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        kas_activateAutoScrollingForView(contentView)
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

    lazy var scrollView = ScrollableView().then {
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    lazy var contentView = UIView().then { view in
        scrollView.addSubview(view)
        view.snp.makeConstraints { (m) in
            m.edges.equalTo(scrollView)
            m.width.equalTo(scrollView)
        }
    }

    // logo & name
    let logoView = UIImageView(image: R.image.login_logo())
    let nameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textColor = UIColor(netHex: 0x24272B)
        $0.text = HDWalletManager.instance.account().name
    }

    // address & copy button
    lazy var addressBackView = UIView().then { view in
        view.backgroundColor = UIColor(netHex: 0xF3F5F9)
        view.addSubview(addressLabel)
        view.addSubview(copyButton)

        addressLabel.snp.makeConstraints { (m) in
            m.left.equalTo(view).offset(16)
            m.centerY.equalTo(view)
        }

        copyButton.snp.makeConstraints { (m) in
            m.top.bottom.right.equalTo(view)
            m.left.equalTo(addressLabel.snp.right)
            m.size.equalTo(CGSize(width: 56, height: 56))
        }
    }

    let addressLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = UIColor(netHex: 0x3E4A59)
        $0.numberOfLines = 2
        $0.text = HDWalletManager.instance.bag().address.description
    }

    let copyButton = UIButton().then {
        $0.setImage(R.image.icon_button_paste_gray(), for: .normal)
        $0.setImage(R.image.icon_button_paste_gray()?.highlighted, for: .highlighted)

    }

    let tokenNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 18)
        $0.textColor = UIColor(netHex: 0x24272B)
        $0.numberOfLines = 0
    }

    let qrcodeImageView = UIImageView()

    let amountButton = UIButton().then {
        $0.setTitle(R.string.localizable.receivePageTokenAmountButtonTitle(), for: .normal)
        $0.setTitleColor(UIColor(netHex: 0x007AFF), for: .normal)
        $0.setTitleColor(UIColor(netHex: 0x007AFF).highlighted, for: .highlighted)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
    }

    let noteTitleTextFieldView = TitleTextFieldView(title: R.string.localizable.receivePageTokenNoteLabel())

    func setupView() {

        navigationBarStyle = .clear
        if case .token = style {
            navigationItem.title = R.string.localizable.receivePageTitle()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.icon_nav_share_black(), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(onShare))
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: token.backgroundColors)

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

        contentView.addSubview(logoView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressBackView)
        contentView.addSubview(qrcodeImageView)

        logoView.snp.makeConstraints { (m) in
            m.top.equalTo(contentView).offset(18)
            m.centerX.equalTo(contentView)
            m.size.equalTo(CGSize(width: 48, height: 48))
        }

        nameLabel.snp.makeConstraints { (m) in
            m.top.equalTo(logoView.snp.bottom).offset(10)
            m.centerX.equalTo(contentView)
        }

        addressBackView.snp.makeConstraints { (m) in
            m.top.equalTo(nameLabel.snp.bottom).offset(15)
            m.left.equalTo(contentView).offset(24)
            m.right.equalTo(contentView).offset(-24)
            m.height.equalTo(56)
        }

        switch style {
        case .default:
            qrcodeImageView.snp.makeConstraints { (m) in
                m.top.equalTo(addressBackView.snp.bottom).offset(20)
                m.centerX.equalTo(contentView)
                m.size.equalTo(CGSize(width: 170, height: 170))
                m.bottom.equalTo(contentView).offset(-30)
            }
        case .token:
            contentView.addSubview(tokenNameLabel)
            contentView.addSubview(amountButton)
            contentView.addSubview(noteTitleTextFieldView)

            tokenNameLabel.snp.makeConstraints { (m) in
                m.top.equalTo(addressBackView.snp.bottom).offset(20)
                m.left.right.equalTo(addressBackView)
            }

            qrcodeImageView.snp.makeConstraints { (m) in
                m.top.equalTo(tokenNameLabel.snp.bottom).offset(20)
                m.centerX.equalTo(contentView)
                m.size.equalTo(CGSize(width: 170, height: 170))
            }

            amountButton.snp.makeConstraints { (m) in
                m.top.equalTo(qrcodeImageView.snp.bottom).offset(20)
                m.centerX.equalTo(contentView)
            }

            noteTitleTextFieldView.snp.makeConstraints { (m) in
                m.top.equalTo(amountButton.snp.bottom).offset(20)
                m.left.equalTo(contentView).offset(24)
                m.right.equalTo(contentView).offset(-24)
                m.bottom.equalTo(contentView).offset(-30)
            }

            noteTitleTextFieldView.textField.kas_setReturnAction(.done(block: {
                $0.resignFirstResponder()
            }))

        }

        tokenNameLabel.text = "sdaflksdaseaufewaiewafweauwaufesaumseaiaskfewaf"
    }

    func bind() {
        copyButton.rx.tap
            .bind {
                UIPasteboard.general.string = HDWalletManager.instance.bag().address.description
                Toast.show(R.string.localizable.walletHomeToastCopyAddress(), duration: 1.0)
            }.disposed(by: rx.disposeBag)

        amountButton.rx.tap
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
                                        })
                })
            }.disposed(by: rx.disposeBag)

        amountBehaviorRelay.asDriver()
            .map { [weak self] in
                guard let `self` = self else { return "" }
                if let amount = $0 {
                    return "\(amount) \(self.token.symbol)"
                } else {
                    return R.string.localizable.receivePageTokenNameLabel(self.token.name)
                }
            }
            .drive(tokenNameLabel.rx.text).disposed(by: rx.disposeBag)

        Observable.combineLatest(amountBehaviorRelay.asObservable(), noteTitleTextFieldView.textField.rx.text.asObservable())
            .map {
                ViteURI.transfer(address: self.bag.address, tokenId: self.token.id, amount: BigInt($0 ?? ""), data: $1)
            }
            .bind(to: uriBehaviorRelay).disposed(by: rx.disposeBag)

        uriBehaviorRelay.asObservable()
            .map {
                $0.string()
            }
            .bind {
                QRCodeHelper.createQRCode(string: $0) { [weak self] image in
                    self?.qrcodeImageView.image = image
                }
            }
            .disposed(by: rx.disposeBag)
    }

    @objc func onShare() {

    }
}
