//
//  VectorsHelper.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 26.11.22.
//

import Foundation

class VectorsHelper{
    public static func getAngle(v1:VectorNode, v2: VectorNode)->Double{
        return scalarProduct(v1: v1, v2: v2) / (vectorModule(v: v1) * vectorModule(v: v2))
    }
    
    public static func scalarProduct(v1:VectorNode, v2: VectorNode)->Double{
        let spep1 = CGPoint(x: v1.endPoint!.x - v1.startPoint!.x, y: v1.endPoint!.y - v1.startPoint!.y)
        let spep2 = CGPoint(x: v2.endPoint!.x - v2.startPoint!.x, y: v2.endPoint!.y - v2.startPoint!.y)
        
        return spep1.x * spep2.x + spep1.y * spep2.y
    }
    
    public static func vectorModule(v:VectorNode)->Double{
        let spep = CGPoint(x: v.endPoint!.x - v.startPoint!.x, y: v.endPoint!.y - v.startPoint!.y)
        
        return sqrt(pow(spep.x, 2) + pow(spep.y, 2))
    }
    
    public static func findEndPoint(for v1: VectorNode, v2: VectorNode, point: CGPoint)->CGPoint{
        let fixX = v2.endPoint!.x
        let testY = (-pow(v1.startPoint!.x, 2) + v1.startPoint!.x * v2.endPoint!.x - pow(v1.startPoint!.y, 2) + v2.endPoint!.y * v1.startPoint!.y + v1.startPoint!.x * fixX - v2.endPoint!.x * fixX) / (-v1.startPoint!.y + v2.endPoint!.y)
        
        let fixY = v2.endPoint!.y
        let testX = (-pow(v1.startPoint!.x, 2) + v1.startPoint!.x * v2.endPoint!.x - pow(v1.startPoint!.y, 2) + v2.endPoint!.y * v1.startPoint!.y + v1.startPoint!.y * fixY - v2.endPoint!.y * fixY) / (-v1.startPoint!.x + v2.endPoint!.x)
        
        let p1 = CGPoint(x: fixX, y: testY)
        let p2 = CGPoint(x: testX, y: fixY)
        
        return getLength(p1, point) < getLength(p2, point) ? p1 : p2
    }
    
    public static func getLength(_ startPoint: CGPoint, _ endPoint: CGPoint) -> Double{
        let x = pow(startPoint.x - endPoint.x, 2)
        let y = pow(startPoint.y - endPoint.y, 2)
        let lenth = sqrt(x+y)
        return lenth
    }
}
