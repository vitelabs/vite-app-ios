//
//  BaseTableViewController.swift
//  Vite
//
//  Created by Stone on 2018/8/27.
//  Copyright © 2018年 Vite. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class BaseTableViewController: BaseViewController {

    fileprivate(set) var tableView: UITableView

    init(_ style: UITableViewStyle = .plain) {
        tableView = UITableView(frame: CGRect.zero, style: style)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        super.init(coder: aDecoder)
    }

    override var navigationTitleView: UIView? {
        didSet { layoutTableView() }
    }

    override var customHeaderView: UIView? {
        didSet { layoutTableView() }
    }

    private func layoutTableView() {
        if let customHeaderView = customHeaderView {
            tableView.snp.remakeConstraints { (m) in
                m.top.equalTo(customHeaderView.snp.bottom)
                m.left.right.bottom.equalTo(view)
            }
        } else if let navigationTitleView = navigationTitleView {
            tableView.snp.remakeConstraints { (m) in
                m.top.equalTo(navigationTitleView.snp.bottom)
                m.left.right.bottom.equalTo(view)
            }
        } else {
            tableView.snp.remakeConstraints { (m) in
                m.edges.equalTo(view)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .scrollableAxes
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (m) in
            m.edges.equalTo(view)
        }
    }
}

extension BaseTableViewController: UITableViewDelegate {}

extension BaseTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
