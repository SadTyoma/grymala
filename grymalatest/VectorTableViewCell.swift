//
//  VectorTableViewCell.swift
//  grymalatest
//
//  Created by Artem Shuneyko on 17.11.22.
//

import UIKit

class VectorTableViewCell: UITableViewCell {



    @IBOutlet weak var color: UIView!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var points: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setPointText(startPoint: CGPoint, endPoint: CGPoint){
        points.text = "(\(startPoint.x); \(startPoint.y)) -> (\(endPoint.x); \(endPoint.y))"
        let lengthStringValue = NSString(format:"%.4f", getLenth(startPoint, endPoint))
        length.text = "Length: \(lengthStringValue))"
    }
    
    public func setColor(color: UIColor){
        self.color.backgroundColor = color
    }
    
    private func getLenth(_ startPoint: CGPoint, _ endPoint: CGPoint) -> Double{
        let x = pow(startPoint.x - endPoint.x, 2)
        let y = pow(startPoint.y - endPoint.y, 2)
        let lenth = sqrt(x+y)
        return lenth
    }
}
