//
//  GameScene.swift
//  grymala_test
//
//  Created by Artem Shuneyko on 15.11.22.
//

import SpriteKit
import GameplayKit

class GridScene: SKScene, UIGestureRecognizerDelegate {
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
    private var horizontalHelp = true
    private var verticalHelp = true
    private var toVectorHelp = true
    private var angleHelp = true
    
    override func didMove(to: SKView) {
        grid = GridNode(blockSize: Constants.blockSize, rows:Constants.rowsAndCols, cols:Constants.rowsAndCols)
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
            
            horizontalHelp = true
            verticalHelp = true
            toVectorHelp = true
            angleHelp = true
        }
    }
    
    private func saveChanges(){
        let vec = VectorsManager.shared.vectorsAsNodes.first { vector in
            return vector.fillColor.isEqual(selectedVector?.fillColor)
        }
        if let vec = vec, let grid = grid{
            vec.startPoint = grid.gridPosition(point: selectedVector!.startPoint!)
            vec.endPoint = grid.gridPosition(point: selectedVector!.endPoint!)
            VectorsManager.shared.reloadDataForVector(vec)
            
            let newSP = grid.gridPosition(row: Int(vec.startPoint!.y + Constants.halfRAC), col: Int(vec.startPoint!.x + Constants.halfRAC))
            let newEP = grid.gridPosition(row: Int(vec.endPoint!.y + Constants.halfRAC), col: Int(vec.endPoint!.x + Constants.halfRAC))
            selectedVector?.changePosition(startPoint: newSP, endPoint: newEP)
        }
    }
        
    @objc private func gridPanHandle(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .began {

        }else if recognizer.state == .changed {
            var translation = recognizer.translation(in: recognizer.view!)
                translation = CGPoint(x: translation.x, y: -translation.y)

            panForTranslation(translation: translation)

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


    private func panForTranslation(translation: CGPoint) {
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
            if !needHorizontalHelp(vector: vector, point: sp) && !needVerticalHelp(vector: vector, point: sp) && !toVectorHelp(vector: vector, point: sp){
                vector.changePosition(startPoint: sp)
            }
        }else if endPointSelected{
            if !angleHelp(vector: vector, point: ep) && !needHorizontalHelp(vector: vector, point: ep) && !needVerticalHelp(vector: vector, point: ep) && !toVectorHelp(vector: vector, point: ep){
                vector.changePosition(endPoint: ep)
            }
        }else{
            vector.changePosition(startPoint: sp, endPoint: ep)
        }
    }
    
    private func angleHelp(vector: VectorNode,point: CGPoint)->Bool{
        let allVectors = getVectorsNodes().filter { vec in
            return !vec.fillColor.isEqual(vector.fillColor)
        }
        let filtredVectors = allVectors.filter { vec in
            return vec.startPoint!.equalTo(vector.startPoint!)
        }
        if endPointSelected && filtredVectors.count > 0{
            let vector2 = filtredVectors.first!
            let vector1Copy = vector.copy() as! VectorNode
            vector1Copy.startPoint = vector.startPoint
            vector1Copy.endPoint = point
            let needToRemove = angleDiff(v1: vector1Copy, v2: vector2)
            if angleHelp && needToRemove{
                let ep = VectorsHelper.findEndPoint(for: vector, v2: vector2, point: point)
                if VectorsHelper.getLength(grid!.gridPosition(point: vector.startPoint!), grid!.gridPosition(point: ep)) < 1{
                    return false
                }
                vector.changePosition(endPoint: ep)
                angleHelp = false
                return true
            }else if !needToRemove{
                angleHelp = true
            }
        }
        
        return false
    }
    
    private func toVectorHelp(vector: VectorNode, point: CGPoint)->Bool{
        let pointOnGrid = grid!.gridPosition(point: point)
        let allVectors = getVectorsNodes().filter { vec in
            return !vec.fillColor.isEqual(vector.fillColor)
        }
        let filtredVectors = allVectors.filter { vec in
            let sp = grid!.gridPosition(point: vec.startPoint!)
            let ep = grid!.gridPosition(point: vec.endPoint!)
            return (pointsDiff(p1:sp.x, p2:pointOnGrid.x) && pointsDiff(p1: sp.y, p2: pointOnGrid.y)) || (pointsDiff(p1: ep.y, p2: pointOnGrid.y) && pointsDiff(p1: ep.x, p2: pointOnGrid.x))
        }
        
        if filtredVectors.count > 0{
            guard toVectorHelp else {return false}
            let firstVec = filtredVectors.first!
            let sp = grid!.gridPosition(point: firstVec.startPoint!)
            let ep = grid!.gridPosition(point: firstVec.endPoint!)
            let vecPoint = pointsDiff(p1:sp.x, p2:pointOnGrid.x) && pointsDiff(p1: sp.y, p2: pointOnGrid.y) ?
            firstVec.startPoint :
            pointsDiff(p1: ep.y, p2: pointOnGrid.y) && pointsDiff(p1: ep.x, p2: pointOnGrid.x) ?
            firstVec.endPoint :
            nil
            
            guard let vecPoint = vecPoint else {return false}
            if startPointSelected{
                vector.changePosition(startPoint: vecPoint)
                toVectorHelp = false
                return true
            }else if endPointSelected{
                vector.changePosition(endPoint: vecPoint)
                toVectorHelp = false
                return true
            }
        }else{
            toVectorHelp = true
        }
        
        return false
    }
    
    private func pointsDiff(p1:Double, p2:Double)->Bool{
        return abs(p1 - p2) < 0.5
    }
    
    private func angleDiff(v1:VectorNode, v2:VectorNode)->Bool{
        let cosValue = VectorsHelper.getAngle(v1: v1, v2: v2)
        return abs(cosValue) < 0.25
    }
    
    private func needHorizontalHelp(vector: VectorNode, point: CGPoint)->Bool{
        let pointOnGrid = grid!.gridPosition(point: point)
        if startPointSelected{
            let endPoint = grid!.gridPosition(point: vector.endPoint!)
            let needToRemove = pointsDiff(p1:endPoint.y, p2:pointOnGrid.y)
            if horizontalHelp && needToRemove{
                let resultPoint = CGPoint(x: pointOnGrid.x + Constants.halfRAC, y: endPoint.y + Constants.halfRAC)
                vector.changePosition(startPoint: grid!.gridPosition(row: Int(resultPoint.y), col: Int(resultPoint.x)))
                horizontalHelp = false
                return true
            }else if !needToRemove{
                horizontalHelp = true
            }
        }else if endPointSelected{
            let startPoint = grid!.gridPosition(point: vector.startPoint!)
            let needToRemove = pointsDiff(p1:startPoint.y, p2:pointOnGrid.y)
            if horizontalHelp && needToRemove{
                let resultPoint = CGPoint(x: pointOnGrid.x + Constants.halfRAC, y: startPoint.y + Constants.halfRAC)
                vector.changePosition(endPoint: grid!.gridPosition(row: Int(resultPoint.y), col: Int(resultPoint.x)))
                horizontalHelp = false
                return true
            }else if !needToRemove{
                horizontalHelp = true
            }
        }
        return false
    }
    
    private func needVerticalHelp(vector: VectorNode, point: CGPoint)->Bool{
        let pointOnGrid = grid!.gridPosition(point: point)
        if startPointSelected{
            let endPoint = grid!.gridPosition(point: vector.endPoint!)
            let needToRemove = pointsDiff(p1:endPoint.x ,p2:pointOnGrid.x)
            if verticalHelp && needToRemove{
                let resultPoint = CGPoint(x: endPoint.x + Constants.halfRAC, y: pointOnGrid.y + Constants.halfRAC)
                vector.changePosition(startPoint: grid!.gridPosition(row: Int(resultPoint.y), col: Int(resultPoint.x)))
                verticalHelp = false
                return true
            }else if !needToRemove{
                verticalHelp = true
            }
        }else if endPointSelected{
            let startPoint = grid!.gridPosition(point: vector.startPoint!)
            let needToRemove = pointsDiff(p1:startPoint.x , p2:pointOnGrid.x)
            if verticalHelp && needToRemove{
                let resultPoint = CGPoint(x: startPoint.x + Constants.halfRAC, y: pointOnGrid.y + Constants.halfRAC)
                vector.changePosition(endPoint: grid!.gridPosition(row: Int(resultPoint.y), col: Int(resultPoint.x)))
                verticalHelp = false
                return true
            }else if !needToRemove{
                verticalHelp = true
            }
        }
        return false
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
            
            let newSP = grid?.gridPosition(row: Int(sp!.y + Constants.halfRAC), col: Int(sp!.x + Constants.halfRAC))
            let newEP = grid?.gridPosition(row: Int(ep!.y + Constants.halfRAC), col: Int(ep!.x + Constants.halfRAC))
            
            let vector = VectorNode(fillColor: color!, startPoint: newSP!, endPoint: newEP!)
            grid!.addChild(vector)
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
