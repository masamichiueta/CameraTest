//
//  ShutterButton.swift
//  CameraTest
//
//  Created by UetaMasamichi on 2017/03/04.
//  Copyright © 2017 Masamichi Ueta. All rights reserved.
//

import UIKit

@IBDesignable class ShutterButton: UIButton {

    @IBInspectable var buttonColor: UIColor = UIColor.red {
        didSet {
            circleLayer.fillColor = buttonColor.cgColor
        }
    }

    @IBInspectable var arcColor: UIColor = UIColor.white {
        didSet {
            arcLayer.strokeColor = arcColor.cgColor
        }
    }

    private var arcWidth: CGFloat {
        return bounds.width * 0.09090
    }

    private var arcMargin: CGFloat {
        return bounds.width * 0.03030
    }

    lazy private var circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = self.circlePath.cgPath
        layer.fillColor = self.buttonColor.cgColor
        return layer
    }()

    lazy private var arcLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = self.arcPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = self.arcColor.cgColor
        layer.lineWidth = self.arcWidth
        return layer
    }()

    private var circlePath: UIBezierPath {
        let side = self.bounds.width - self.arcWidth*2 - self.arcMargin*2
        return UIBezierPath(
            roundedRect: CGRect(x: bounds.width/2 - side/2, y: bounds.width/2 - side/2, width: side, height: side),
            cornerRadius: side/2
        )
    }

    private var arcPath: UIBezierPath {
        return UIBezierPath(
            arcCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
            radius: self.bounds.width/2 - self.arcWidth/2,
            startAngle: -CGFloat(M_PI_2),
            endAngle: CGFloat(M_PI*2.0) - CGFloat(M_PI_2),
            clockwise: true
        )
    }

    public convenience init(frame: CGRect, buttonColor: UIColor) {
        self.init(frame: frame)
        self.buttonColor = buttonColor
    }

    override var isHighlighted: Bool {
        didSet {
            circleLayer.opacity = isHighlighted ? 0.5 : 1.0
        }
    }

    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle("", for: state)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if arcLayer.superlayer != layer {
            layer.addSublayer(arcLayer)
        } else {
            arcLayer.path = arcPath.cgPath
            arcLayer.lineWidth = arcWidth
        }

        if circleLayer.superlayer != layer {
            layer.addSublayer(circleLayer)
        }
    }
}
