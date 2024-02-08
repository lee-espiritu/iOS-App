//
//  CustomNavBar.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 1/2/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Class Description: Custom class that sets up a Nav Bar UI

import UIKit

class CustomNavBar: UIView {

    // Add a UILabel property for the title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black // Customize the text color
        label.font = UIFont.boldSystemFont(ofSize: 20) // Customize the font
        label.textAlignment = .center
        return label
    }()
    
    //Method to initialise the frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    //Method to initialise the title for the view
    convenience init(title: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        setTitle(title)
    }    

    //Method to initialise the view from the storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    //Method to Set up the UI for the Nav Bar
    private func setupUI() {
        // Customize the appearance navigation bar
        backgroundColor = UIColor(red: CGFloat(207)/255, green: CGFloat(237)/255, blue: CGFloat(253)/255, alpha: 1)

        // Add the title label as a subview
        addSubview(titleLabel)

        // Set up constraints for the title label (adjust as needed)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        // Adjust the y-coordinate with a constant value to move the label down
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 20).isActive = true
    }
    
    // Method to set the title
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
