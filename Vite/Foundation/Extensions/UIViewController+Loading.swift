//
//  UIViewController+Loading.swift
//  Vite
//
//  Created by Water on 2018/9/18.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlter(title: String, message: String, cancel: String, done: String, doneHandler: @escaping () -> Void, cancelHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: { _ in
            if let cancelHandler = cancelHandler {
                cancelHandler()
            }
        })
        let doneAction = UIAlertAction(title: done, style: .destructive, handler: { _ in
            doneHandler()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func displayConfirmAlter(title: String, message: String, done: String, doneHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: done, style: .destructive, handler: {_ in
            doneHandler()
        })
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func displayConfirmAlter(title: String, done: String, doneHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: done, style: .destructive, handler: {_ in
            doneHandler()
        })
        alertController.addAction(doneAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
