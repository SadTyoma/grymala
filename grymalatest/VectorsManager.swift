//
//  VectorsManager.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 17.11.22.
//

import Foundation
import CoreData
import UIKit

protocol VectorsManagerDelegate{
    func vectorArrayChanged()
    func reloadItem(at row: Int)
}

class VectorsManager{
    public static let shared = VectorsManager()
    //public var delegate: VectorsManagerDelegate?
    public let multicastVectorsManagerDelegate = MulticastDelegate<VectorsManagerDelegate>()
    private let context: NSManagedObjectContext?
    private let entity: NSEntityDescription?
    private var vectorsAsObjects: [NSManagedObject] = []
    public var vectorsAsNodes: [VectorNode] = []{
        didSet {
            //delegate?.vectorArrayChanged()
            self.multicastVectorsManagerDelegate.invokeForEachDelegate { delegate in
                delegate.vectorArrayChanged()
            }
        }
    }
    
    private init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "VectorEntity", in: context!)
    }
    
    public func saveAll(){
        for vector in vectorsAsObjects {
            context?.delete(vector)
        }
        
        for vector in vectorsAsNodes{
            saveVector(startPoint: vector.startPoint!, endPoint: vector.endPoint!, color: vector.fillColor.toHex!)
        }
    }
    
    public func reloadDataForVector(_ vector: VectorNode){
        multicastVectorsManagerDelegate.invokeForEachDelegate { delegate in
            delegate.reloadItem(at: vectorsAsNodes.firstIndex(of: vector)!)
        }
    }
    
    public func saveVector(startPoint: CGPoint, endPoint: CGPoint, color: String){
        let newVector = NSManagedObject(entity: entity!, insertInto: context!)
        
        newVector.setValue(startPoint.x, forKey: "sx")
        newVector.setValue(startPoint.y, forKey: "sy")
        
        newVector.setValue(endPoint.x, forKey: "ex")
        newVector.setValue(endPoint.y, forKey: "ey")
        
        newVector.setValue(color, forKey: "color")
        
        do{
            try context?.save()
        }
        catch{
            print("\(error)")
        }
    }
    
    public func getData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VectorEntity")
        request.returnsObjectsAsFaults = false
        
        do{
            vectorsAsObjects = try context?.fetch(request) as! [NSManagedObject]
        }catch{
            print("\(error)")
        }
        
        vectorsAsNodes = []
        for vector in vectorsAsObjects{
            let color = UIColor(hex: vector.value(forKey: "color") as! String)!
            let startPoint = CGPoint(x: CGFloat(vector.value(forKey: "sx") as! Int32), y: CGFloat(vector.value(forKey: "sy") as! Int32))
            let endPoint = CGPoint(x: CGFloat(vector.value(forKey: "ex") as! Int32), y: CGFloat(vector.value(forKey: "ey") as! Int32))
            
            let node = VectorNode(fillColor: color, startPoint: startPoint, endPoint: endPoint)
            
            vectorsAsNodes.append(node)
        }
    }
}
