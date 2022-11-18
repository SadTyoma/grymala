//
//  VectorsViewController.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 17.11.22.
//

import UIKit

class VectorsViewController: UIViewController {
    private var tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: "VectorTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")

        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .lightGray
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
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
            cell.setStartPointText(point: data.startPoint!)
            cell.setEndPointText(point: data.endPoint!)
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VectorsManager.shared.vectorsAsNodes.count
    }
}
