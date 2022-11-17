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
    
    override func didMove(to: SKView) {
        grid = GridNode(blockSize: blockSize, rows:rowsAndCols, cols:rowsAndCols)
        if let grid = grid {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            addChild(grid)
        }
        VectorsManager.shared.delegate = self
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
}

extension GridScene: VectorsManagerDelegate{
    func vectorArrayChanged() {
        let vec = VectorsManager.shared.vectorsAsNodes.last
        let sp = vec?.startPoint
        let ep = vec?.endPoint
        let color = vec?.fillColor
        
        let newSP = grid?.gridPosition(row: Int(sp!.y + halfRAC), col: Int(sp!.x + halfRAC))
        let newEP = grid?.gridPosition(row: Int(ep!.y + halfRAC), col: Int(ep!.x + halfRAC))
        
        let vector = VectorNode(arrowWithFillColor: color!, startPoint: newSP!, endPoint: newEP!)
        grid!.addChild(vector)
    }
}
