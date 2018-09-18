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

class ScanViewController: BaseViewController {

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
        do {
            let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = view.bounds
            view.layer.addSublayer(videoPreviewLayer)
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }

    func setupUIComponents() {
        navigationBarStyle = .custom(tintColor: UIColor.white, backgroundColor: UIColor(netHex: 0x24272B))
        navigationItem.title = LocalizationStr("Scan QR Code")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: R.image.icon_nav_photo_black(), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(self.pickeImage(_:)))

        do {
            let screenWidth = UIScreen.main.bounds.width
            let topBackgroundView = UIView().then {
                $0.frame =  CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth * 0.2)
                $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            }
            let leftBackgroundView = UIView().then {
                $0.frame =  CGRect(x: 0, y: topBackgroundView.frame.maxY, width: screenWidth * 0.2, height: screenWidth * 0.6)
                $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            }
            let bottomBackgroundView = UIView().then {
                $0.frame = CGRect(x: 0, y: leftBackgroundView.frame.maxY, width: screenWidth, height: UIScreen.main.bounds.height)
                $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            }
            let rightBackgroundView = UIView().then {
                $0.frame = CGRect(x: screenWidth * 0.8, y: leftBackgroundView.frame.minY, width: screenWidth * 0.2, height: screenWidth * 0.6)
                $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            }
            view.addSubview(topBackgroundView)
            view.addSubview(bottomBackgroundView)
            view.addSubview(leftBackgroundView)
            view.addSubview(rightBackgroundView)
        }

        do {
            let flashButton = UIButton().then {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.backgroundColor = .red
            }
            view.addSubview(flashButton)
            NSLayoutConstraint.activate([
                flashButton.widthAnchor.constraint(equalToConstant: 50),
                flashButton.heightAnchor.constraint(equalToConstant: 50),
                flashButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                flashButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
                ])
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
            switch uri {
            case .address:
                showAlert(string: result)
            case .transfer(let address, let tokenId, let amount, let note):
                let tokenId = tokenId ?? Token.Currency.vite.rawValue
                let sendViewController = SendViewController(tokenId: tokenId, address: address, amount: amount, note: note)
                guard var viewControllers = navigationController?.viewControllers else { return }
                _ = viewControllers.popLast()
                viewControllers.append(sendViewController)
                self.navigationController?.setViewControllers(viewControllers, animated: true)
            }
        } else {
            showAlert(string: result)
        }
    }

    func showAlert(string: String) {
        let alertController = UIAlertController.init()
        let action = UIAlertAction.init(title: LocalizationStr("OK"), style: .default) { [weak self](_) in
            self?.navigationController?.popViewController(animated: true)
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
        captureSession.stopRunning()
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
                self.captureSession.stopRunning()
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.handleQRResult(stringValue)
            }
        }
    }
}
