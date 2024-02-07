//
//  ExercisePlanTableViewCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//

import UIKit

class ExercisePlanTableViewCell: UITableViewCell {

    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var exercise: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editCellAppearance()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func editCellAppearance() {
        // Set the background color of the cell to clear
        backgroundColor = .clear
        
        // Set rounding to the corners
        layer.cornerRadius = 10
        
        // Set the stroke color to cyan
        layer.borderColor = UIColor.cyan.cgColor
        layer.borderWidth = 1.0 // Increase the stroke width
    }

}
