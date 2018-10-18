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

class ScanViewController: BaseViewController {

    let scanViewWidth: CGFloat = 262.0
    let scanViewCenterYOffset: CGFloat = 70.0
    let captureSession = AVCaptureSession()

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
                let captureMetadataOutput = AVCaptureMetadataOutput()
                self.captureSession.addOutput(captureMetadataOutput)
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                let scanRect = CGRect(x: (videoPreviewLayer.bounds.size.width - self.scanViewWidth)/2,
                                      y: (videoPreviewLayer.bounds.size.height - kNavibarH - self.scanViewWidth)/2 - self.scanViewCenterYOffset,
                                      width: self.scanViewWidth,
                                      height: self.scanViewWidth)
                let rectOfInterest = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: scanRect)
                captureMetadataOutput.rectOfInterest = rectOfInterest
            } catch {
                plog(level: .severe, log: "Init AVCaptureDeviceInput error")
            }
        }
    }

    func setupUIComponents() {
        navigationItem.title = R.string.localizable.scanPageTitle.key.localized()
        navigationBarStyle = .custom(tintColor: UIColor.white, backgroundColor: UIColor(netHex: 0x24272B))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.icon_nav_photo_black(), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(self.pickeImage(_:)))

        do {

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
    }

    @objc func pickeImage(_ button: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
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

    func handleQRResult(_ result: String?) {
        guard let result = result else { return }
        if let uri = ViteURI.parser(string: result) {
            captureSession.stopRunning()
            switch uri {
            case .transfer(let address, let tokenId, _, _, let note):

                self.view.displayLoading(text: "")
                let tokenId = tokenId ?? Token.Currency.vite.rawValue
                TokenCacheService.instance.tokenForId(tokenId) { [weak self] (result) in
                    guard let `self` = self else { return }
                    self.view.hideLoading()
                    switch result {
                    case .success:
                        let amount = uri.amountToBigInt()
                        let sendViewController = SendViewController(tokenId: tokenId, address: address, amount: amount, note: note)
                        guard var viewControllers = self.navigationController?.viewControllers else { return }
                        _ = viewControllers.popLast()
                        viewControllers.append(sendViewController)
                        self.navigationController?.setViewControllers(viewControllers, animated: true)
                    case .failure(let error):
                        Toast.show(error.localizedDescription)
                    }
                }
            }
        } else {
            self.showAlert(string: result)
        }
    }

    func showAlert(string: String) {
        self.captureSession.stopRunning()
        let alertController = UIAlertController.init()
        let action = UIAlertAction.init(title: LocalizationStr("OK"), style: .default) { [weak self](_) in
            self?.captureSession.startRunning()
        }
        alertController.addAction(action)
        alertController.title = string
        present(alertController, animated: true, completion: nil)
    }

    func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
        if let image = image, let ciImage = CIImage.init(image: image) {
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)) {
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options: options)
            return features
        }
        return nil
    }
}

extension ScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.handleQRResult(stringValue)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var stringValue: String?
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let features = detectQRCode(pickedImage), !features.isEmpty {
                for case let row as CIQRCodeFeature in features {
                    stringValue = row.messageString
                }
            }
        }

        dismiss(animated: true) {
            if stringValue != nil {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.handleQRResult(stringValue)
            } else {
                Toast.show(R.string.localizable.scanPageQccodeNotFound.key.localized())
            }
        }
    }
}
