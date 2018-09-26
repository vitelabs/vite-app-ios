//
//  PasswordInputView.swift
//  Vite
//
//  Created by Water on 2018/9/9.
//  Copyright © 2018年 vite labs. All rights reserved.
//
import Foundation
import UIKit

protocol PasswordInputViewDelegate: class {
    func inputFinish(passwordView: PasswordInputView, password: String)
}

enum SecretType {
    case asterisk, point, plaintext
}

protocol DeleteTextFieldDelegate: class {
    func textFieldBackKeyPressed(_ textField: UITextField)
}

class DeleteTextField: UITextField {
    weak var deleteTextFieldDelegate: DeleteTextFieldDelegate?
    override func deleteBackward() {
        super.deleteBackward()
        if deleteTextFieldDelegate != nil {
            deleteTextFieldDelegate?.textFieldBackKeyPressed(self)
        }
    }
}

public class PasswordInputView: UIView {
    var totalCount = 6
    let textField = DeleteTextField(frame: .zero)
    var password = ""
    var partitionColor = Colors.lineGray
    var partitionWidth: CGFloat = 6.0
    weak var delegate: PasswordInputViewDelegate?

    var wordView: UIView?
    var secretLabels = [UILabel]()
    var secretViews = [UIView]()
    var secretType = SecretType.asterisk
    var initalized = false

    override public func layoutSubviews() {
        super.layoutSubviews()

        if initalized == false {
            initalizeUI(frame: self.frame)
            initalized = true
        }
    }

    func initalizeUI(frame: CGRect) {
        textField.frame = frame
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIColor.clear
        textField.tintColor =  UIColor.clear
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldChange(sender:)), for: .editingChanged)
        addSubview(textField)
        wordView = createWordView(size: frame.size)
        addSubview(wordView!)
        self.backgroundColor = UIColor.clear
    }

    func createWordView(size: CGSize) -> UIView {
        let h = size.height
        let w = size.width
        let center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        let labelH = h
        let labelW = (w - (2.0 * partitionWidth * (CGFloat(totalCount)-1))) / 6
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: w, height: h)))
        view.backgroundColor = .clear
        view.center = center

        for i in 0..<totalCount {
            let x = CGFloat(i) * (labelW + partitionWidth*2)
            let y = CGFloat(0)
            if secretType == .asterisk {
                let label = UILabel(frame: CGRect(x: x, y: y+5, width: labelW, height: labelH))
                label.backgroundColor = UIColor.clear
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 18)
                label.adjustsFontSizeToFitWidth = true
                view.addSubview(label)
                secretLabels.append(label)
            } else if secretType == .point {
                let v = UIView(frame: CGRect(x: x, y: y, width: labelW, height: labelH))
                v.backgroundColor = UIColor.white
                view.addSubview(v)
                secretViews.append(v)
            } else {
                let label = UILabel(frame: CGRect(x: x, y: y, width: labelW, height: labelH))
                label.backgroundColor = UIColor.clear
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 18)
                label.textColor = UIColor.black
                label.adjustsFontSizeToFitWidth = true
                view.addSubview(label)
                secretLabels.append(label)
            }
            let line  = UIView()
            line.frame =  CGRect(x: x, y: labelH-1, width: labelW, height: 1)
            line.backgroundColor = partitionColor
            view.addSubview(line)
        }
        return view
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        textField.becomeFirstResponder()
    }

    public override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    @objc func textFieldChange(sender: UITextField) {
        let text = textField.text == nil ? "" : textField.text!
        let textCount = text.count

        if  textCount <= 6 {
            updateView(text: text)
            if textCount == self.totalCount {
                self.delegate?.inputFinish(passwordView: self, password: text)
            }
        }
    }

    func updateView(text: String) {
        if secretType == .asterisk {
            for i in 0..<totalCount {
                if i < text.count {
                    secretLabels[i].text = "*"
                } else {
                    secretLabels[i].text = ""
                }
            }
        } else  if secretType == .point {
            secretViews.forEach({ view in
                view.subviews.forEach({ point in
                    point.removeFromSuperview()
                })
            })
            for i in 0..<secretViews.count {
                    let view = secretViews[i]
                    let size = view.bounds.size
                    let w = size.width
                    let point = UIView(frame: CGRect(origin: .zero, size: CGSize(width: w * 0.25, height: w * 0.25)))
                    point.center = CGPoint(x: w / 2.0, y: w / 2.0)
                    point.layer.cornerRadius = w / 8.0
                    point.clipsToBounds = true
                    view.addSubview(point)
            }
        } else {
            for i in 0..<totalCount {
                if i < text.count {
                    let start = String.Index(encodedOffset: i)
                    let end = String.Index(encodedOffset: i+1)
                    let substring = String(text[start..<end])
                    secretLabels[i].text = substring
                } else {
                    secretLabels[i].text = ""
                }
            }
        }
    }
}

extension PasswordInputView: UITextFieldDelegate, DeleteTextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text == nil ? "" : textField.text!
        let textCount = text.count + string.count - range.length

        if  textCount <= 6 {
            return true
        } else {
            return false
        }
    }

    func textFieldBackKeyPressed(_ textField: UITextField) {

    }
}
