//
//  VectorTableViewCell.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 17.11.22.
//

import UIKit

class VectorTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var endPointLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setStartPointText(point: CGPoint){
        startPointLabel.text = " (\(point.x); \(point.y))"
    }
    
    public func setEndPointText(point: CGPoint){
        endPointLabel.text = " (\(point.x); \(point.y))"
    }
    
    public func setColor(color: UIColor){
        colorView.backgroundColor = color
    }
}
