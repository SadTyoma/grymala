//
//  ContainerViewController.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 17.11.22.
//

import UIKit

class ContainerViewController: UIViewController {
    private enum VCState{
        case opened
        case closed
    }
    
    private let vectorVC = VectorsViewController()
    private let addVC = AddViewController()
    private let gridVC = GridViewController()
    private var navVC: UINavigationController?
    private var vectorsVCState: VCState = .closed
    private var addVCState: VCState = .closed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        // Do any additional setup after loading the view.
        
        addChildVCs()
    }
    

    func addChildVCs(){
        addChild(vectorVC)
        view.addSubview(vectorVC.view)
        vectorVC.didMove(toParent: self)

        addChild(addVC)
        view.addSubview(addVC.view)
        addVC.didMove(toParent: self)
        
        gridVC.delegate = self
        let navVC = UINavigationController(rootViewController: gridVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
    }

}

extension ContainerViewController: GridViewControllerDelegate{
    func vectorsButtonDidTapped() {
        switch vectorsVCState {
        case .opened:
            vectorsVCState = .closed
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
                self.navVC?.view.frame.origin.x = 0
            }
        case .closed:
            vectorsVCState = .opened
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
                self.navVC?.view.frame.origin.x = self.gridVC.view.frame.size.width / 3
            }
        }
    }
    
    func addButtonDidTapped() {
        switch addVCState {
        case .opened:
            addVCState = .closed
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
                self.navVC?.view.frame.origin.x = 0
            }
        case .closed:
            addVCState = .opened
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
                self.navVC?.view.frame.origin.x = -self.gridVC.view.frame.size.width * 2 / 3
            }
        }
    }
    
    
}
