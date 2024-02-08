//
//  ExercisePlanTableViewCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Class Description: Contains the dynamic prototype cell content within the main tableview in Set Up Daily Program Screen

import UIKit

class ExercisePlanTableViewCell: UITableViewCell {
    
    //Reference outlets for the prototype cell
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var exercise: UILabel!
    
    //Default function created on class creation
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Modify the cell appearance
        editCellAppearance()
    }

    //Default function created on class creation
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Function to edit the table view cells UI appearance
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
