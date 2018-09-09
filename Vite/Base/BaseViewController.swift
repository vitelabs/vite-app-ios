//
//  BaseViewController.swift
//  Vite
//
//  Created by Stone on 2018/8/27.
//  Copyright © 2018年 Vite. All rights reserved.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {

    var automaticallyShowDismissButton: Bool = true

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        if navigationController?.viewControllers.first === self && automaticallyShowDismissButton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(_onCancel))
        }

    }

    @objc fileprivate func _onCancel() {
        dismiss(animated: true, completion: nil)
    }

    func dismiss() {
        if navigationController == nil || navigationController?.viewControllers.first === self {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
