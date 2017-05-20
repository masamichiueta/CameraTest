//
//  FocusView.swift
//  CameraTest
//
//  Created by Masamichi Ueta on 2017/05/19.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit

class FocusView: UIView {

    lazy private var focusLayer: CAShapeLayer = {
        let layer = CAShapeLayer()

        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        focusLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        //focusLayer.bounds = self.bounds
        let rec = CGRect(x: 0, y: 0, width: 100, height: 100)
        focusLayer.path = UIBezierPath(roundedRect: rec, cornerRadius: 10).cgPath
//        focusLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100)).cgPath
        focusLayer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(focusLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
