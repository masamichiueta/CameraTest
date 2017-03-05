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

    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var previewViewController: PreviewLayerViewController?

    var images: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraController = CameraController()
        self.previewViewController?.cameraController = cameraController

        UIApplication.shared.isStatusBarHidden = true
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
    
    @IBAction func capture(_ sender: ShutterButton) {
        self.cameraController.captureStillImage(completionHandler: {[unowned self] image, metadata in
            self.images.insert(image, at: 0)
            self.collectionView.reloadData()
        })
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = self.images[indexPath.row]
        return cell
    }
}
