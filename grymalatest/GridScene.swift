//
//  GameScene.swift
//  grymala_test
//
//  Created by Artem Shuneyko on 15.11.22.
//

import SpriteKit
import GameplayKit

class GridScene: SKScene, UIGestureRecognizerDelegate {
    private let blockSize = 40.0
    private let rowsAndCols = 51
    private let halfRAC = 25.0
    
    private var fingureIsOnNinja = false
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var grid: GridNode?
    private var arrLength = 0
    private var animating = false
    private var selectedVector: VectorNode?
    private var gridSelected = true
    private var startPointSelected = false
    private var endPointSelected = false
    
    override func didMove(to: SKView) {
        grid = GridNode(blockSize: blockSize, rows:rowsAndCols, cols:rowsAndCols)
        if let grid = grid {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            addChild(grid)
        }
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gridPanHandle))
          self.view!.addGestureRecognizer(panGestureRecognizer)
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandle))
          self.view!.addGestureRecognizer(longPressGestureRecognizer)
        panGestureRecognizer.delegate = self
        longPressGestureRecognizer.delegate = self
        
        VectorsManager.shared.multicastVectorsManagerDelegate.add(delegate: self)
        VectorsManager.shared.getData()
    }
    
    @objc private func longPressHandle(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .began {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)
            selectNode(touchLocation: touchLocation)
        }
        else if recognizer.state == .ended {
            gridSelected = true
            startPointSelected = false
            endPointSelected = false
            saveChanges()
            selectedVector = nil
        }
    }
    
    private func saveChanges(){
        var vec = VectorsManager.shared.vectorsAsNodes.first { vector in
            return vector.fillColor.isEqual(selectedVector?.fillColor)
        }
        if let vec = vec, let grid = grid{
            vec.startPoint = grid.gridPosition(point: selectedVector!.startPoint!)
            vec.endPoint = grid.gridPosition(point: selectedVector!.endPoint!)
            VectorsManager.shared.reloadDataForVector(vec)
            
            let newSP = grid.gridPosition(row: Int(vec.startPoint!.y + halfRAC), col: Int(vec.startPoint!.x + halfRAC))
            let newEP = grid.gridPosition(row: Int(vec.endPoint!.y + halfRAC), col: Int(vec.endPoint!.x + halfRAC))
            selectedVector?.changePosition(startPoint: newSP, endPoint: newEP)
        }
    }
        
    @objc private func gridPanHandle(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .began {

        }else if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
                translation = CGPoint(x: translation.x, y: -translation.y)

            self.panForTranslation(translation: translation)

            recognizer.setTranslation(CGPointZero, in: recognizer.view)
        }else if recognizer.state == .ended {

        }
    }
    
    func selectNode(touchLocation: CGPoint){
        let correctLocation = CGPoint(x: touchLocation.x - grid!.position.x, y: touchLocation.y - grid!.position.y)
        
        let touchedVector = getVectorsNodes().filter { vector in
            return vector.pointBelongsToVector(point: correctLocation)
        }
        selectedVector = touchedVector.count > 0 ? touchedVector.first : nil
        
        if let selectedVector = selectedVector{
            startPointSelected = selectedVector.pointBelongsToStartPoint(point: correctLocation)
            endPointSelected = selectedVector.pointBelongsToEndPoint(point: correctLocation)
        }
        
        gridSelected = selectedVector == nil
    }


    func panForTranslation(translation: CGPoint) {
        if gridSelected{
            gridPanTranslation(translation: translation)
        }else if let selectedVector = selectedVector{
            vectorPanTranslation(vector: selectedVector, translation: translation)
        }
    }
    
    func vectorPanTranslation(vector: VectorNode, translation: CGPoint){
        var sp = vector.startPoint!
        var ep = vector.endPoint!
        
        sp.x = sp.x + translation.x
        sp.y = sp.y + translation.y
        ep.x = ep.x + translation.x
        ep.y = ep.y + translation.y
        
        if startPointSelected{
            vector.changePosition(startPoint: sp)
        }else if endPointSelected{
            vector.changePosition(endPoint: ep)
        }else{
            vector.changePosition(startPoint: sp, endPoint: ep)
        }
    }
    
    func gridPanTranslation(translation: CGPoint){
        if let grid = grid {
            let position = grid.position
            
            var newYPos = position.y + translation.y
            var newXPos = position.x + translation.x
            
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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        /* Called when a touch begins */
//        for touch in touches{
//            let location = touch.location(in: self)
//
//            if self.atPoint(location) == self.grid {
//
//                fingureIsOnNinja = true  //make this true so it will only move when you touch it.
//
//            }
//        }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if fingureIsOnNinja {
//
//            if let touch = touches.first, let grid = grid {
//
//                let touchLoc = touch.location(in: self)
//                let prevTouchLoc = touch.previousLocation(in: self)
//                var newYPos = grid.position.y + (touchLoc.y - prevTouchLoc.y)
//                var newXPos = grid.position.x + (touchLoc.x - prevTouchLoc.x)
//
//                let bottomY = (grid.frame.height - frame.height) / 2
//                let topY = -bottomY
//                if newYPos < topY{
//                    newYPos = topY
//                }
//                else if newYPos > bottomY{
//                    newYPos = bottomY
//                }
//
//                let leftX = (grid.frame.width - frame.width) / 2
//                let rightX = -leftX
//                if newXPos < rightX{
//                    newXPos = rightX
//                }
//                else if newXPos > leftX{
//                    newXPos = leftX
//                }
//
//                grid.position = CGPoint (x:newXPos, y:newYPos)
//            }
//        }
//    }
//
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//    }
    
    
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
     }
}

extension GridScene: VectorsManagerDelegate{
    func reloadItem(at row: Int) {}
    
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
