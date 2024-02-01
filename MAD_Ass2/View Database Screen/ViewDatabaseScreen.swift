//
//  ViewDatabaseScreen.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//  Version: 1.0
//  Description: This class is responsible for handling the contents of the ViewDatabaseScreen
//

import UIKit

class ViewDatabaseScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Required

        //Apply background gradient
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        view.addSubview(CustomNavBar)
        
        
        reloadData()
    }
    
    func reloadData(){

    }

    
    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
