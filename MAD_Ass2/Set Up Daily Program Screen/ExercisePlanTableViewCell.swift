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
        
        // Create a bottom border
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1) // Adjust the height as needed
        bottomBorder.backgroundColor = UIColor.cyan.cgColor // Set the color of the bottom border
        
        // Add the bottom border to the cell's layer
        layer.addSublayer(bottomBorder)
        
        // Create a custom background gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 5, width: frame.size.width, height: frame.size.height - 10)
        gradientLayer.colors = [UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2).cgColor, UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.2).cgColor] // Set gradient colors with lighter alpha component
        gradientLayer.cornerRadius = 5 // Set rounding to the corners
        layer.insertSublayer(gradientLayer, at: 0) // Add the gradient layer below other layers

    }

}
