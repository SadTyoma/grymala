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
    
    public func pointBelongsToVector(point: CGPoint) -> Bool{
        let strokedPath = path!.copy(strokingWithWidth: 10.0,
                                     lineCap: .round,
                                     lineJoin: .miter,
                                     miterLimit: 50.0)
        let pointIsNearPath = strokedPath.contains(point) || path!.contains(point)
        return pointIsNearPath
    }
    
    public func pointBelongsToStartPoint(point: CGPoint) -> Bool{
        let rad = 30.0
        let x = pow(abs(startPoint!.x) - abs(point.x), 2)
        let y = pow(abs(startPoint!.y) - abs(point.y), 2)
        let d = sqrt(x + y)
        
        return d <= rad
    }
    
    public func pointBelongsToEndPoint(point: CGPoint) -> Bool{
        let rad = 30.0
        let x = pow(endPoint!.x - point.x, 2)
        let y = pow(endPoint!.y - point.y, 2)
        let d = sqrt(x + y)
        
        return d <= rad
    }
    
    public func changePosition(startPoint: CGPoint, endPoint: CGPoint){
        let vectorPath = VectorNode.VectorCGPath(arrowFromStart: startPoint, to: endPoint)
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.path = vectorPath
    }
    
    public func changePosition(startPoint: CGPoint){
        let vectorPath = VectorNode.VectorCGPath(arrowFromStart: startPoint, to: self.endPoint!)
        self.startPoint = startPoint
        self.path = vectorPath
    }
    
    public func changePosition(endPoint: CGPoint){
        let vectorPath = VectorNode.VectorCGPath(arrowFromStart: self.startPoint!, to: endPoint)
        self.endPoint = endPoint
        self.path = vectorPath
    }
    
    private static func VectorCGPath(arrowFromStart start: CGPoint, to end: CGPoint)->CGPath{
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
        let vectorPath = VectorNode.VectorCGPath(arrowFromStart: startPoint, to: endPoint)
        
        self.init(path: vectorPath)
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.lineWidth = arrowLineWidth
        self.startPoint = startPoint
        self.endPoint = endPoint
        name = Constants.vectorName
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
}

