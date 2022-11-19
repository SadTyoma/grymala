//
//  ViewController.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 17.11.22.
//

import UIKit
import SpriteKit

protocol GridViewControllerDelegate{
    func vectorsButtonDidTapped()
    func addButtonDidTapped()
}

class GridViewController: UIViewController, GridViewControllerDelegate {
    public var delegate: GridViewControllerDelegate?
    public var scene: GridScene?
    
    override func loadView() {
        self.view = SKView.init(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(vectorsButtonDidTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addButtonDidTapped))
        
        if let view = self.view as! SKView? {
            if let gridScene = SKScene(fileNamed: "GridScene") {
                self.scene = gridScene as? GridScene
                view.presentScene(gridScene)
            }
        }
    }

    @objc public func vectorsButtonDidTapped(){
        delegate?.vectorsButtonDidTapped()
    }

    @objc func addButtonDidTapped() {
        delegate?.addButtonDidTapped()
    }
}

