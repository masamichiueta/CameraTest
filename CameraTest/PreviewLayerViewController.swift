//
//  PreviewLayerViewController.swift
//  CameraTest
//
//  Created by UetaMasamichi on 2017/03/03.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewLayerView : UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}

class PreviewLayerViewController: UIViewController {

    var previewLayer:AVCaptureVideoPreviewLayer! {
        get {
            return view.layer as! AVCaptureVideoPreviewLayer
        }
    }

    var cameraController:CameraController? {
        didSet {
            cameraController?.previewLayer = previewLayer
        }
    }

    override func loadView() {
        view = PreviewLayerView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
