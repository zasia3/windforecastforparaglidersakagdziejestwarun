//
//  WindView.swift
//  WindForecast
//
//  Created by MacBook Pro on 20.10.2018.
//  Copyright © 2018 Joanna Zatorska. All rights reserved.
//

import UIKit

final class WindView: UIView {
    
    var count: Int?
    var boldOrder: Int?
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers = nil
        
        guard let count = count else { return }
        
        let angleInterval:CGFloat = 360.0 / CGFloat(count)
        
        for i in 0..<count {
            let color = i == boldOrder ? UIColor.red : UIColor.lightGray
            drawArrow(length: 50, angle: angleInterval * CGFloat(i), color: color)
        }
    }
    
    private func drawArrow(length: CGFloat, angle: CGFloat, color: UIColor) {
        
        let arrow = UIBezierPath()
        
        let centerPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        
        arrow.addArrow(start: centerPoint, end: CGPoint(x: centerPoint.x, y: centerPoint.y - length), length: 20)
        
        arrow.apply(CGAffineTransform(translationX: -centerPoint.x, y: -centerPoint.y))
        arrow.apply(CGAffineTransform(rotationAngle: angle.degreesToRadians))
        arrow.apply(CGAffineTransform(translationX: centerPoint.x, y: centerPoint.y))
        let arrowLayer = CAShapeLayer()
        arrowLayer.strokeColor = color.cgColor
        arrowLayer.lineWidth = 3
        arrowLayer.path = arrow.cgPath
        arrowLayer.fillColor = UIColor.clear.cgColor
        arrowLayer.lineJoin = CAShapeLayerLineJoin.round
        arrowLayer.lineCap = CAShapeLayerLineCap.round
        
        self.layer.addSublayer(arrowLayer)
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
}

extension UIBezierPath {
    func addArrow(start: CGPoint, end: CGPoint, length: CGFloat) {
        self.move(to: start)
        self.addLine(to: end)
        
        let capAngle = CGFloat(45.0.degreesToRadians)
        
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + length * cos(CGFloat(Double.pi) - startEndAngle + capAngle), y: end.y - length * sin(CGFloat(Double.pi) - startEndAngle + capAngle))
        let arrowLine2 = CGPoint(x: end.x + length * cos(CGFloat(Double.pi) - startEndAngle - capAngle), y: end.y - length * sin(CGFloat(Double.pi) - startEndAngle - capAngle))
        
        self.addLine(to: arrowLine1)
        self.move(to: end)
        self.addLine(to: arrowLine2)
    }
}
