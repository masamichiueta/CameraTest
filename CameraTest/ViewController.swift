//
//  ViewController.swift
//  CameraTest
//
//  Created by Masamichi Ueta on 2017/03/03.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var videoPreviewView: UIView!
    var cameraController:CameraController!

    fileprivate var previewViewController: PreviewLayerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraController = CameraController()
        self.previewViewController?.cameraController = cameraController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cameraController.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreviewViewController" {
            self.previewViewController = segue.destination as? PreviewLayerViewController
        }
    }
}

