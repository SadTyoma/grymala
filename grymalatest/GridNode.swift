//
//  GridNode.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 17.11.22.
//

import SpriteKit

class GridNode:SKSpriteNode {
    var rows:Int!
    var cols:Int!
    var blockSize:CGFloat!
    
    convenience init?(blockSize:CGFloat,rows:Int,cols:Int) {
        guard let texture = GridNode.gridTexture(blockSize: blockSize,rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        self.blockSize = blockSize
        self.rows = rows
        self.cols = cols
        name = Constants.gridName
        drawNumbers()
    }
    
    class func gridTexture(blockSize:CGFloat,rows:Int,cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset:CGFloat = 0.5
        // Draw vertical lines
        for i in 0...cols {
            let x = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        SKColor.white.setStroke()
        bezierPath.lineWidth = 1.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    
    func drawNumbers(){
        let midRows = rows / 2
        let midCols = cols / 2
        for i in -midCols...midCols {
            var pos = gridPosition(row: midRows, col: i + midCols)
            let label = SKLabelNode(text: "\(i)")
            label.fontSize = 15.0
            pos.x += label.frame.width / 2
            label.position = pos
            self.addChild(label)
        }
        
        for i in -midRows...midRows {
            var pos = gridPosition(row: i + midRows, col: midCols)
            let label = SKLabelNode(text: "\(i)")
            label.fontSize = 15.0
            pos.x += label.frame.width / 2
            label.position = pos
            self.addChild(label)
        }
    }
    
    func gridPosition(row:Int, col:Int) -> CGPoint {
        let x = CGFloat(col) * blockSize - (blockSize * CGFloat(cols)) / 2.0
        let y = CGFloat(rows - row) * blockSize - (blockSize * CGFloat(rows)) / 2.0
        return CGPoint(x:x, y:-y)
    }
}
