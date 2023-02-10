//
//  SetCardView.swift
//  SET Game
//
//  Created by Максим Митрофанов on 10.02.2023.
//

import UIKit

class SetCardView: UIView {
    let maxValueOffset = 0.05
    let minValueOffset = 0.95
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        drawDiamond(in: rect)
    }
    
    private func setup() {
        self.backgroundColor = .purple
    }
    
    func setup(for card: SetCard) {
        
    }
}

private extension SetCardView {
    func drawDiamond(in rect: CGRect) {
        //Dimond
        let topPoint = CGPoint(x: rect.midX, y: rect.maxY * 0.05)
        let bottomPoint = CGPoint(x: rect.midX, y: rect.maxY * 0.95)
        let leftPoint = CGPoint(x: rect.maxX * 0.05, y: rect.midY)
        let rightPoint = CGPoint(x: rect.maxX * 0.95, y: rect.midY)

        
        //Drawing a triangle
        let path = UIBezierPath()
        path.move(to: topPoint)
        path.addLine(to: rightPoint)
        path.addLine(to: bottomPoint)
        path.addLine(to: leftPoint)
        path.close()
        
        //Setting attributes
        UIColor.gray.setFill()
        UIColor.black.setStroke()
        path.lineWidth = 5
        path.fill()
        path.stroke()
    }
    
    func drawOval(in rect: CGRect) {
        //Oval
        let ovalMaxY = rect.maxY * 0.95
        let ovalMinY = rect.maxY * 0.05
        let ovalMaxX = rect.maxX * 0.75
        let ovalMinX = rect.maxX * 0.25
        
        let topLeftPointForOval = CGPoint(x: ovalMinX, y: ovalMinY)
        let topRightPointForOval = CGPoint(x: ovalMaxX, y: ovalMinY)
        let bottomLeftPointForOval = CGPoint(x: ovalMinX, y: ovalMaxY)
        let bottomRightPointForOval = CGPoint(x: ovalMaxX, y: ovalMaxY)
        
        let leftMiddlePointForOval = CGPoint(x: rect.maxX * 0.05, y: rect.midY)
        let rightMiddlePointForOval = CGPoint(x: rect.maxX * 0.95, y: rect.midY)
        
        //Control points
        let topLeftPointOfBounds = CGPoint(x: rect.maxX * 0.05, y: rect.maxY * 0.1)
        let topRightPointOfBounds = CGPoint(x: rect.maxX * 0.95, y: rect.maxY * 0.1)
        let bottomLeftPointOfBounds = CGPoint(x: rect.maxX * 0.05, y: rect.maxY * 0.9)
        let bottomRightPointOfBounds = CGPoint(x: rect.maxX * 0.95, y: rect.maxY * 0.9)
        
        
        
        
        let path = UIBezierPath()
        path.move(to: leftMiddlePointForOval)
        
        //Top Left Curve
        path.addQuadCurve(to: topLeftPointForOval, controlPoint: topLeftPointOfBounds)
        
        //Top Line
        path.addLine(to: topRightPointForOval)
        
        //Top Right Curve
        path.addQuadCurve(to: rightMiddlePointForOval, controlPoint: topRightPointOfBounds)
        
        //Bottom Right Curve
        path.addQuadCurve(to: bottomRightPointForOval, controlPoint: bottomRightPointOfBounds)
        
        //Bottom Line
        path.addLine(to: bottomLeftPointForOval)
        
        //Bottom Left Curve
         path.addQuadCurve(to: leftMiddlePointForOval, controlPoint: bottomLeftPointOfBounds)
        
        //Setting attributes
        UIColor.gray.setFill()
        UIColor.black.setStroke()
        path.lineWidth = 5
        path.fill()
        path.stroke()
    }
}
