//
//  GradientHelper.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 25/1/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Class Description: Custom helper class for setting background gradient

import UIKit

class GradientHelper: NSObject {
    static func addGradient(to view: UIView, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint){
        //Create a CAGradientLayer instance
        let gradientLayer = CAGradientLayer()
        
        //Set the colors of the gradient layer using colors input
        gradientLayer.colors = colors.map { $0.cgColor }
        
        //Set the locations of the gradient colors
        gradientLayer.locations = [0.0, 1.0]
        
        //Set the start and end points of the gradient using startPoint and endPoint input
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        //Set the gradient layer frame to match the bounds of the specified view
        gradientLayer.frame = view.bounds
        
        //Insert the gradient layer as the bottom layer of the specified view's layer hierarchy
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
