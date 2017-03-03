//
//  CameraController.swift
//  CameraTest
//
//  Created by UetaMasamichi on 2017/03/03.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraControllerDelegate: class {
    func didCameraAccessDenied()
}


class CameraController: NSObject {

    weak var delegate: CameraControllerDelegate?

    var previewLayer:AVCaptureVideoPreviewLayer? {
        didSet {
            previewLayer?.session = session
        }
    }

    fileprivate var currentCameraDevice:AVCaptureDevice?

    // MARK: Private properties

    fileprivate var sessionQueue:DispatchQueue = DispatchQueue(label: "io.loquat.Loquat.session_access_queue", attributes: [])

    fileprivate var session:AVCaptureSession!
    fileprivate var backCameraDevice:AVCaptureDevice?
    fileprivate var frontCameraDevice:AVCaptureDevice?
    fileprivate var stillCameraOutput:AVCaptureStillImageOutput!
    fileprivate var videoOutput:AVCaptureVideoDataOutput!
    fileprivate var metadataOutput:AVCaptureMetadataOutput!

    override init() {
        super.init()
        self.initializeSession()
    }


    func initializeSession() {
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto

        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)

        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)

        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo,
                                          completionHandler: { (granted:Bool) -> Void in
                                            if granted {
                                                self.configureSession()
                                            }
                                            else {
                                                self.handleDeniedAccess()
                                            }
            })
        case .authorized:
            self.configureSession()
        case .denied, .restricted:
            self.handleDeniedAccess()
        }
    }

    // MARK: - Camera Control
    func startRunning() {
        performConfiguration { () -> Void in
            self.session.startRunning()
        }
    }


    func stopRunning() {
        performConfiguration { () -> Void in
            self.session.stopRunning()
        }
    }

    // MARK: Still image capture
    func captureStillImage(completionHandler handler:@escaping ((_ image:UIImage, _ metadata:NSDictionary) -> Void)) {
        sessionQueue.async { () -> Void in

            let connection = self.stillCameraOutput.connection(withMediaType: AVMediaTypeVideo)

            connection?.videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue)!

            self.stillCameraOutput.captureStillImageAsynchronously(from: connection) {
                (imageDataSampleBuffer, error) -> Void in

                if error == nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)

                    let metadata: NSDictionary = CMCopyDictionaryOfAttachments(nil, imageDataSampleBuffer!, CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))!

                    if let image = UIImage(data: imageData!) {
                        DispatchQueue.main.async { () -> Void in
                            handler(image, metadata)
                        }
                    }
                }
                else {
                    print("error while capturing still image: \(error)")
                }
            }
        }
    }
}

// MARK: - Private
private extension CameraController {

    func performConfiguration(_ block: @escaping (() -> Void)) {
        sessionQueue.async { () -> Void in
            block()
        }
    }

    func configureSession() {
        configureDeviceInput()
        configureStillImageCameraOutput()
    }


    func configureDeviceInput() {

        performConfiguration {
            let availableCameraDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for device in availableCameraDevices as! [AVCaptureDevice] {
                if device.position == .back {
                    self.backCameraDevice = device
                }
                else if device.position == .front {
                    self.frontCameraDevice = device
                }
            }

            self.currentCameraDevice = self.backCameraDevice

            if let backCameraInput = try? AVCaptureDeviceInput(device: self.backCameraDevice) {
                if self.session.canAddInput(backCameraInput) {
                    self.session.addInput(backCameraInput)
                }
            }
        }
    }


    func configureStillImageCameraOutput() {
        performConfiguration { () -> Void in
            self.stillCameraOutput = AVCaptureStillImageOutput()
            self.stillCameraOutput.outputSettings = [
                AVVideoCodecKey  : AVVideoCodecJPEG,
                AVVideoQualityKey: 0.9
            ]

            if self.session.canAddOutput(self.stillCameraOutput) {
                self.session.addOutput(self.stillCameraOutput)
            }
        }
    }

    func handleDeniedAccess() {
        self.delegate?.didCameraAccessDenied()
    }
}
