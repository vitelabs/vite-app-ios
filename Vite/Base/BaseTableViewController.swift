//
//  BaseTableViewController.swift
//  Vite
//
//  Created by Stone on 2018/8/27.
//  Copyright © 2018年 Vite. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .scrollableAxes
        }
//        tableView.dataSource = self
//        tableView.delegate = self
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: tableView, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: tableView, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 0))
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
