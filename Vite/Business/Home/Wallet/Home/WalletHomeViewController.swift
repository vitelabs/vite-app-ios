//
//  WalletHomeViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

class WalletHomeViewController: BaseTableViewController {

    enum Section: Int {
        case address = 0
        case token
        case max
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    fileprivate func setupView() {

        let qrcodeItem = UIBarButtonItem(image: R.image.bar_icon_qrcode(), style: .plain, target: nil, action: nil)
        let scanItem = UIBarButtonItem(image: R.image.bar_icon_scan(), style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = qrcodeItem
        navigationItem.rightBarButtonItem = scanItem

        qrcodeItem.rx.tap.bind { [weak self] _ in
            self?.navigationController?.pushViewController(QRCodeViewController(), animated: true)
        }.disposed(by: rx.disposeBag)

        scanItem.rx.tap.bind {  [weak self] _ in
            self?.navigationController?.pushViewController(ScanViewController(), animated: true)
        }.disposed(by: rx.disposeBag)

    }

    // MARK: - UITableViewDataSource & UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.max.rawValue
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { fatalError() }
        switch section {
        case .address:
            return 1
        case .token:
            return 3
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let section = Section(rawValue: indexPath.section) else { fatalError() }

        switch section {
        case .address:
            let cell: WalletHomeAddressCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        case .token:
            let cell: WalletHomeTokenCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
