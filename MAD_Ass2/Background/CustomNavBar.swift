//
//  CustomNavBar.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 1/2/2024.
//

import UIKit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    convenience init(title: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        setTitle(title)
    }    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        // Customize the appearance navigation bar
        backgroundColor = UIColor(red: CGFloat(207)/255, green: CGFloat(237)/255, blue: CGFloat(253)/255, alpha: 1)

        // Add the title label as a subview
        addSubview(titleLabel)

        // Set up constraints for the title label (adjust as needed)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    // Method to set the title
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
