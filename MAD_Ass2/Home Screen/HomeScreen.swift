//
//  ViewController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//  Version: 1.0
//  Description: Home screen for the fitness app
//

import UIKit

class HomeScreen: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var exerciseTabBarItem: UITabBarItem!
    @IBOutlet weak var dailyProgramTabBarItem: UITabBarItem!
    @IBOutlet weak var recordTabBarItem: UITabBarItem!
    @IBOutlet weak var logTabBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        //Disable navbar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //Add custom navbar
        view.addSubview(CustomNavBar(title: "Home Screen"))
        
        //Required
        tabBar.delegate = self
    }
    
    @IBAction func viewDBPressed(_ sender: Any) {
        print("View DB button Pressed")
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "ViewDatabaseScreen") as? ViewDatabaseScreen{
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func setUpExercisePressed(_ sender: Any) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetUpExerciseScreen") as? SetUpExerciseScreen{
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func setUpDailyProgramPressed(_ sender: Any) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetUpDailyProgramScreen") as? SetUpDailyProgramScreen{
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func recordWorkoutPressed(_ sender: Any) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "RecordWorkout") as? RecordWorkout{
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    @IBAction func displayLogsPressed(_ sender: Any) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayLogs") as? DisplayLogsScreen{
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Check if the selected item is the homeTabBarItem
        if item == homeTabBarItem {
            print("Home tab bar item pressed")
        } else if item == exerciseTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetUpExerciseScreen") as? SetUpExerciseScreen{
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else if item == dailyProgramTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetUpDailyProgramScreen") as? SetUpDailyProgramScreen{
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else if item == recordTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "RecordWorkout") as? RecordWorkout{
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else if item == logTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayLogs") as? DisplayLogsScreen{
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
