//
//  SelectDayCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 30/1/2024.
//  Version: 1.0
//  Description: Prototype Cell class that holds the left and right label connections
//

import UIKit

class SelectDayCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Public function to round corners
    func roundCorners(corners: UIRectCorner) {
        let cornerRadius: CGFloat = 10
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }


}
