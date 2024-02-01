//
//  GradientHelper.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 25/1/2024.
//

import UIKit

class GradientHelper: NSObject {
    static func addGradient(to view: UIView, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
