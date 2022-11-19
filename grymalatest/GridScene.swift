//
//  GameScene.swift
//  grymala_test
//
//  Created by Artem Shuneyko on 15.11.22.
//

import SpriteKit
import GameplayKit

class GridScene: SKScene {
    private let blockSize = 40.0
    private let rowsAndCols = 51
    private let halfRAC = 25.0
    
    private var fingureIsOnNinja = false
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var grid: GridNode?
    private var arrLength = 0
    private var animating = false
    
    override func didMove(to: SKView) {
        grid = GridNode(blockSize: blockSize, rows:rowsAndCols, cols:rowsAndCols)
        if let grid = grid {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            addChild(grid)
        }
        VectorsManager.shared.multicastVectorsManagerDelegate.add(delegate: self)
        VectorsManager.shared.getData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches{
            let location = touch.location(in: self)
            
            if self.atPoint(location) == self.grid {
                
                fingureIsOnNinja = true  //make this true so it will only move when you touch it.
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if fingureIsOnNinja {
            
            if let touch = touches.first, let grid = grid {
                
                let touchLoc = touch.location(in: self)
                let prevTouchLoc = touch.previousLocation(in: self)
                var newYPos = grid.position.y + (touchLoc.y - prevTouchLoc.y)
                var newXPos = grid.position.x + (touchLoc.x - prevTouchLoc.x)
                
                let bottomY = (grid.frame.height - frame.height) / 2
                let topY = -bottomY
                if newYPos < topY{
                    newYPos = topY
                }
                else if newYPos > bottomY{
                    newYPos = bottomY
                }
                
                let leftX = (grid.frame.width - frame.width) / 2
                let rightX = -leftX
                if newXPos < rightX{
                    newXPos = rightX
                }
                else if newXPos > leftX{
                    newXPos = leftX
                }
                
                grid.position = CGPoint (x:newXPos, y:newYPos)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    public func showVector(at index: Int) {
        guard !animating else {return}
        animating = true
        let children = getVectorsNodes()
        let child = children[index]
        let biggerVector = VectorNode(fillColor: child.fillColor, startPoint: child.startPoint!, endPoint: child.endPoint!, scale: 2.0)
        
        let shapeLayer = CAShapeLayer()
        self.view!.layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.path = child.path
        
        let animation = CABasicAnimation.init(keyPath: "path")
        animation.duration = 1.0
        animation.fromValue  = child.path
        animation.toValue = biggerVector.path
        animation.isRemovedOnCompletion  = true
        
        shapeLayer.add(animation, forKey: "animation")

        let action = SKAction.customAction(withDuration: animation.duration, actionBlock: { (node, timeDuration) in
            (node as! SKShapeNode).path = shapeLayer.presentation()?.path
        })
        
        child.run(SKAction.sequence([action, action.reversed()])) {
            self.animating = false
        }
        shapeLayer.removeFromSuperlayer()
    }
}

extension GridScene: VectorsManagerDelegate{
    func vectorArrayChanged() {
        let vectorsAsNodes = VectorsManager.shared.vectorsAsNodes
        let arrayLength = vectorsAsNodes.count
        if arrayLength > arrLength{
            let vec = vectorsAsNodes.last
            let sp = vec?.startPoint
            let ep = vec?.endPoint
            let color = vec?.fillColor
            
            let newSP = grid?.gridPosition(row: Int(sp!.y + halfRAC), col: Int(sp!.x + halfRAC))
            let newEP = grid?.gridPosition(row: Int(ep!.y + halfRAC), col: Int(ep!.x + halfRAC))
            
            let vector = VectorNode(fillColor: color!, startPoint: newSP!, endPoint: newEP!)
            grid!.addChild(vector)
        }else{
//            let children = getVectorsNodes()
//
//            let filtredChildren = children.filter { child in
//                for vec in vectorsAsNodes{
//                    let start = grid?.gridPosition(row: Int(vec.startPoint!.y + halfRAC), col: Int(vec.startPoint!.x + halfRAC))
//                    let end = grid?.gridPosition(row: Int(vec.endPoint!.y + halfRAC), col: Int(vec.endPoint!.x + halfRAC))
//                    return !child.isSameVector(fillColor: vec.fillColor, startPoint: start!, endPoint: end!)
//                }
//                return false
//            }
//
//            if let delChild = patchedLines.last{
//                delChild.removeFromParent()
//            }
        }
        
        arrLength = arrayLength
    }
    
    public func removeVector(vector: VectorNode){
        let children = getVectorsNodes()
        let toDel = children.first { vec in
            return vec.fillColor.isEqual(vector.fillColor)
        }
        toDel?.removeFromParent()
    }
    
    private func getVectorsNodes() -> [VectorNode]{
        let nodes = grid!.children.filter({ node in
            return node is VectorNode
        }) as! [VectorNode]
        
        return nodes
    }
}
