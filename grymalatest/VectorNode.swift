//
//  VectorNode.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 17.11.22.
//

import UIKit
import SpriteKit

class VectorNode: SKShapeNode{
    private let arrowLineWidth = 1.0
    private static var tailWidth = 5.0
    private static var headWidth = 10.0
    private static var headLength = 20.0
    
    public var startPoint: CGPoint?
    public var endPoint: CGPoint?
    
    private static func ArrowCGPath(arrowFromStart start: CGPoint, to end: CGPoint)->CGPath{
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        let points: [CGPoint] = [
            .init(x: 0, y: tailWidth / 2),
            .init(x: tailLength, y: tailWidth / 2),
            .init(x: tailLength, y: headWidth / 2),
            .init(x: length, y: 0),
            .init(x: tailLength, y: -headWidth / 2),
            .init(x: tailLength, y: -tailWidth / 2),
            .init(x: 0, y: -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        
        return path
    }
    
    convenience init(fillColor: UIColor, startPoint: CGPoint, endPoint: CGPoint){
        let arrowPath = VectorNode.ArrowCGPath(arrowFromStart: startPoint, to: endPoint)
        
        self.init(path: arrowPath)
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.lineWidth = arrowLineWidth
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    convenience init(fillColor: UIColor, startPoint: CGPoint, endPoint: CGPoint, scale: Double){
        VectorNode.tailWidth *= scale
        VectorNode.headWidth *= scale
        VectorNode.headLength *= scale
        self.init(fillColor: fillColor, startPoint: startPoint, endPoint: endPoint)
        VectorNode.tailWidth /= scale
        VectorNode.headWidth /= scale
        VectorNode.headLength /= scale
    }
    
    public func isSameVector(fillColor: UIColor, startPoint: CGPoint, endPoint: CGPoint)->Bool{
        let start = self.startPoint?.equalTo(startPoint)
        let end = self.endPoint?.equalTo(endPoint)
        print("s:\(start!)")
        print("e:\(end!)")
        print("c:\(self.fillColor.isEqual(fillColor))")
        return self.fillColor.isEqual(fillColor) && start! && end!
    }
}

