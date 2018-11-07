//
//  VoteListViewController.swift
//  Vite
//
//  Created by Water on 2018/11/5.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import RxDataSources

class VoteListViewController: BaseViewController {

    let reactor = VoteListReactor()

    let textView = UITextView()
    let textView1 = UITextView()
    let button = UIButton()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupUI() {
        textView.backgroundColor = .blue

        textView1.backgroundColor = .magenta
        textView1.text = "s10"

        button.backgroundColor = .yellow
        button.setTitle("Vote", for: .normal)

        view.addSubview(textView)
        view.addSubview(textView1)
        view.addSubview(button)

        textView.snp.makeConstraints { (m) in
            m.width.height.equalTo(40)
            m.top.left.equalToSuperview()
        }

        textView1.snp.makeConstraints { (m) in
            m.width.height.equalTo(40)
            m.top.equalToSuperview()
            m.centerX.equalToSuperview()
        }

        button.snp.makeConstraints { (m) in
            m.width.height.equalTo(40)
            m.top.right.equalToSuperview()
        }

        view.addSubview(tableView)

        tableView.snp.makeConstraints { (m) in
            m.left.right.bottom.equalToSuperview()
            m.top.equalToSuperview().offset(40)
        }

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func bind() {

        textView.rx.text
            .bind(to: reactor.search)
            .disposed(by: rx.disposeBag)

        button.rx.tap.withLatestFrom(textView1.rx.text)
            .filterNil()
            .bind(to: reactor.vote)
            .disposed(by: rx.disposeBag)

        let result = reactor.result()

        result
            .map { $0.isEmpty }
            .bind {
                print($0)
            }
            .disposed(by: rx.disposeBag)

        result
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, candidate, cell in
               cell.textLabel?.text = candidate.name
            }

            .disposed(by: rx.disposeBag)

        reactor.voteError.asObservable()
            .filterNil()
            .bind { error in
                if !BussinessErrorHandler.hander(error: error, in: self) {
                    Toast.show(error.message)
                }
            }
            .disposed(by: rx.disposeBag)
    }

}
