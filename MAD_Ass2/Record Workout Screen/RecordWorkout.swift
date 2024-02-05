//
//  RecordWorkoutViewController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//

import UIKit

class RecordWorkout: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Apply background gradient
        //GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        // Retrieve the day of the week
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let today = Date()
        let dayOfWeek = dateFormatter.string(from: today)
        let title = "\(dayOfWeek)'s Workout"
        
        //Add the top navbar
        view.addSubview(CustomNavBar(title: title))
    }
    

    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
