//
//  CustomNavBar.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 1/2/2024.
//

import UIKit

import UIKit

class CustomNavBar: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
    }    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        // Customize the appearance navigation bar
        backgroundColor = UIColor(red: CGFloat(207)/255, green: CGFloat(237)/255, blue: CGFloat(253)/255, alpha: 1)

    }
}