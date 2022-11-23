//
//  VectorsViewController.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 17.11.22.
//

import UIKit

protocol VectorsViewControllerDelegate{
    func didSelectVector(at index: Int)
    func didRemoved(vector: VectorNode)
}

class VectorsViewController: UIViewController {
    private var isUpdating = false
    private var tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "VectorTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        return table
    }()
    
    public var delegate: VectorsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .lightGray
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        VectorsManager.shared.multicastVectorsManagerDelegate.add(delegate: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width / 3, height: view.bounds.size.height)
    }
}

extension VectorsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? VectorTableViewCell{
            let data = VectorsManager.shared.vectorsAsNodes[indexPath.row]
            cell.setColor(color: data.fillColor)
            cell.setPointText(startPoint: data.startPoint!, endPoint: data.endPoint!)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VectorsManager.shared.vectorsAsNodes.count
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            isUpdating = true
            let vec = VectorsManager.shared.vectorsAsNodes.remove(at: indexPath.row)
            delegate?.didRemoved(vector: vec)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            isUpdating = false
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectVector(at: indexPath.row)
    }
}

extension VectorsViewController: VectorsManagerDelegate{
    func reloadItem(at row: Int) {
        tableView.reloadRows(at: [IndexPath(item: row, section: 0)], with: .fade)
    }
    
    func vectorArrayChanged() {
        if !isUpdating{
            tableView.reloadData()
        }
    }
}
