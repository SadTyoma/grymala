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
        points.text = "(\(getFormatedNumber(startPoint.x)); \(getFormatedNumber(startPoint.y))) -> (\(getFormatedNumber(endPoint.x)); \(getFormatedNumber(endPoint.y)))"
        let lengthStringValue = NSString(format:"%.4f", VectorsHelper.getLength(startPoint, endPoint))
        length.text = "Length: \(lengthStringValue)"
    }
    
    public func setColor(color: UIColor){
        self.color.backgroundColor = color
    }
    
    private func getFormatedNumber(_ num: CGFloat)->NSString{
        return NSString(format:"%.0f", num)
    }
}
