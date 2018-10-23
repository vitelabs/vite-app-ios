//
//  ScanViewController.swift
//  Vite
//
//  Created by Stone on 2018/9/7.
//  Copyright © 2018年 vite labs. All rights reserved.
//

import UIKit
import AVFoundation
import Then
import SnapKit

import ReactorKit
import RxSwift
import RxCocoa

class ScanViewController: BaseViewController, View {

    var disposeBag = DisposeBag()

    let scanViewWidth: CGFloat = 262.0
    let scanViewCenterYOffset: CGFloat = 70.0

    let captureSession = AVCaptureSession()
    let captureMetadataOutput = AVCaptureMetadataOutput()

    let imagePicker = UIImagePickerController().then { (imagePicker) in
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAVComponents()
        setupUIComponents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if captureSession.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning == true {
            captureSession.stopRunning()
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setupAVComponents() {
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.backgroundColor = UIColor(netHex: 0x24272B).cgColor
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer.frame = view.bounds
        view.layer.addSublayer(videoPreviewLayer)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                self.captureSession.addInput(input)
                self.captureSession.addOutput(self.captureMetadataOutput)
                self.captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                let scanRect = CGRect(x: (videoPreviewLayer.bounds.size.width - self.scanViewWidth)/2,
                                      y: (videoPreviewLayer.bounds.size.height - kNavibarH - self.scanViewWidth)/2 - self.scanViewCenterYOffset,
                                      width: self.scanViewWidth,
                                      height: self.scanViewWidth)
                let rectOfInterest = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: scanRect)
                self.captureMetadataOutput.rectOfInterest = rectOfInterest
            } catch {
                plog(level: .severe, log: "Init AVCaptureDeviceInput error")
            }
        }
    }

    func setupUIComponents() {
        navigationItem.title = R.string.localizable.scanPageTitle.key.localized()
        navigationBarStyle = .custom(tintColor: UIColor.white, backgroundColor: UIColor(netHex: 0x24272B))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.icon_nav_photo_black(), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(self.pickeImage(_:)))

        let clearView = UIView().then {
            $0.backgroundColor = UIColor.clear
            $0.layer.borderColor = UIColor(netHex: 0x0079df).cgColor
            $0.layer.borderWidth = 2
        }

        let topBackgroundView = UIView().then {
            $0.backgroundColor = UIColor(netHex: 0x24272B).withAlphaComponent(0.8)
        }
        let leftBackgroundView = UIView().then {
            $0.backgroundColor = UIColor(netHex: 0x24272B).withAlphaComponent(0.8)
        }
        let bottomBackgroundView = UIView().then {
            $0.backgroundColor = UIColor(netHex: 0x24272B).withAlphaComponent(0.8)
        }
        let rightBackgroundView = UIView().then {
            $0.backgroundColor = UIColor(netHex: 0x24272B).withAlphaComponent(0.8)
        }

        let flashButton = UIButton().then {
            $0.setImage(R.image.icon_button_light(), for: .normal)
            $0.setImage(R.image.icon_button_light()?.highlighted, for: .highlighted)

            guard let device = AVCaptureDevice.default(for: .video) else { return }
            if !device.hasTorch || !device.isTorchAvailable {
                $0.isHidden = true
            }
        }

        view.addSubview(clearView)
        view.addSubview(topBackgroundView)
        view.addSubview(bottomBackgroundView)
        view.addSubview(leftBackgroundView)
        view.addSubview(rightBackgroundView)
        view.addSubview(flashButton)

        clearView.snp.makeConstraints { (m) in
            m.centerX.equalTo(view)
            m.centerY.equalTo(view).offset(-scanViewCenterYOffset)
            m.size.equalTo(CGSize(width: scanViewWidth, height: scanViewWidth))
        }

        topBackgroundView.snp.makeConstraints { (m) in
            m.top.left.right.equalTo(view)
            m.bottom.equalTo(clearView.snp.top)
        }

        bottomBackgroundView.snp.makeConstraints { (m) in
            m.bottom.left.right.equalTo(view)
            m.top.equalTo(clearView.snp.bottom)
        }

        leftBackgroundView.snp.makeConstraints { (m) in
            m.top.equalTo(topBackgroundView.snp.bottom)
            m.bottom.equalTo(bottomBackgroundView.snp.top)
            m.left.equalTo(view)
            m.right.equalTo(clearView.snp.left)
        }

        rightBackgroundView.snp.makeConstraints { (m) in
            m.top.equalTo(topBackgroundView.snp.bottom)
            m.bottom.equalTo(bottomBackgroundView.snp.top)
            m.left.equalTo(clearView.snp.right)
            m.right.equalTo(view)
        }

        flashButton.snp.makeConstraints { (m) in
            m.centerX.equalTo(view)
            m.top.equalTo(clearView.snp.bottom).offset(40)
        }

        flashButton.addTarget(self, action: #selector(switchFlash(_:)), for: .touchUpInside)
    }

    @objc func pickeImage(_ button: UIBarButtonItem) {
        present(imagePicker, animated: true) {}
    }

    @objc func switchFlash(_ sender: UIButton) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasTorch && device.isTorchAvailable {
            try? device.lockForConfiguration()
            if device.torchMode == .off {
                device.torchMode = .on
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        }
    }

    func bind(reactor: ScanViewReactor) {
        imagePicker.rx.didFinishPickingMediaWithInfo
            .map { ScanViewReactor.Action.pickeImage($0[UIImagePickerControllerOriginalImage] as? UIImage) }
            .do(onNext: { [unowned self] (_) in
                self.imagePicker.dismiss(animated: true, completion: nil)
            })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        captureMetadataOutput.rx.metadataOutput
            .map { ScanViewReactor.Action.scanQRCode($0.first) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.toastMessage }
            .filter { $0 != nil }
            .subscribe(onNext: { [unowned self] in
                self.showToast(string: $0!)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] in
                if $0 {
                    self.captureSession.stopRunning()
                    self.view.displayLoading(text: "")
                } else {
                    self.view.hideLoading()
                }
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.alertMessage }
            .filter { $0 != nil }
            .subscribe(onNext: { [unowned self] in
                self.showAlertMessage($0!)
            })
            .disposed(by: disposeBag)

        reactor.state
            .filter { $0.confirmedToken != nil }
            .map { ($0.viteURI!, $0.confirmedToken) }
            .subscribe(onNext: { [weak self] in
                self?.transformToSendScene($0.0, $0.1!)
            })
            .disposed(by: disposeBag)
    }

    func showToast(string: String) {
        Toast.show(string)
        self.captureSession.stopRunning()
        GCD.delay(2, task: { [weak self] in
            self?.captureSession.startRunning()
        })
    }

    func showAlertMessage(_ alertMessage: String) {
        self.captureSession.stopRunning()
        let alertController = UIAlertController.init()
        let action = UIAlertAction.init(title: R.string.localizable.finish.key.localized(), style: .default) { (_) in
            self.captureSession.startRunning()
        }
        alertController.addAction(action)
        alertController.title = alertMessage
        self.present(alertController, animated: true, completion: nil)
    }

    func transformToSendScene(_ uri: ViteURI, _ token: Token) {
        switch uri {
        case let .transfer(address, _, _, _, note):
            self.captureSession.stopRunning()
            let amount = uri.amountToBigInt()
            let sendViewController = SendViewController(token: token, address: address, amount: amount, note: note)
            guard var viewControllers = self.navigationController?.viewControllers else { return }
            _ = viewControllers.popLast()
            viewControllers.append(sendViewController)
            self.navigationController?.setViewControllers(viewControllers, animated: true)
        }
    }
}
