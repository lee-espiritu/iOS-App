//
//  ViewController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Class Description: Handles the View Controller and main oeprations of the apps Home Screen


import UIKit

class HomeScreen: UIViewController, UITabBarDelegate {
    
    //Reference Outlets
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var exerciseTabBarItem: UITabBarItem!
    @IBOutlet weak var dailyProgramTabBarItem: UITabBarItem!
    @IBOutlet weak var recordTabBarItem: UITabBarItem!
    @IBOutlet weak var logTabBarItem: UITabBarItem!
    
    //Default function created on class creation
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
    
    //Function triggered when 'View DB' button is pressed - Pushes the View Database Screen to View Controller
    //Inputs: @sender - The object that triggered the function
    @IBAction func viewDBPressed(_ sender: Any) {
        //Instantiate View Database Screen View Controller and push it.
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "ViewDatabaseScreen") as? ViewDatabaseScreen{
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    //Function triggered when 'Set Up Exercise' button is pressed - Pushes the Set Up Exercise Screen to View Controller
    //Inputs: @sender - The object that triggered the function
    @IBAction func setUpExercisePressed(_ sender: Any) {
        //Instantiate Set Up Exercise Screen View Controller and push it.
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetUpExerciseScreen") as? SetUpExerciseScreen{
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    //Function triggered when 'Set Up Daily Program' button is pressed - Pushes the Set Up Exercise Screen to View Controller
    //Inputs: @sender - The object that triggered the function
    @IBAction func setUpDailyProgramPressed(_ sender: Any) {
        //Instantiate Set Up Daily Program Screen View Controller and push it.
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetUpDailyProgramScreen") as? SetUpDailyProgramScreen{
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    //Function triggered when 'Record Workout' button is pressed - Pushes the Set Up Exercise Screen to View Controller
    //Inputs: @sender - The object that triggered the function
    @IBAction func recordWorkoutPressed(_ sender: Any) {
        //Instantiate Record Workout Screen View Controller and push it.
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "RecordWorkout") as? RecordWorkout{
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    //Function triggered when 'Display Logs' button is pressed - Pushes the Set Up Exercise Screen to View Controller
    //Inputs: @sender - The object that triggered the function
    @IBAction func displayLogsPressed(_ sender: Any) {
        //Instantiate Display Logs Screen View Controller and push it.
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayLogs") as? DisplayLogsScreen{
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    // This function handles the selection of each tab bar item and performs navigation actions accordingly.
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Check if the selected item is the homeTabBarItem
        if item == homeTabBarItem {
            //Do nothing as we are in the home screen already
        } else if item == exerciseTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetUpExerciseScreen") as? SetUpExerciseScreen{
                navigationController?.pushViewController(nextVC, animated: true) //Push Set up Exercise Screen View Controller
            }
        } else if item == dailyProgramTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetUpDailyProgramScreen") as? SetUpDailyProgramScreen{
                navigationController?.pushViewController(nextVC, animated: true) //Push Set Up Daily Program Screen View Controller
            }
        } else if item == recordTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "RecordWorkout") as? RecordWorkout{
                navigationController?.pushViewController(nextVC, animated: true) //Push Record Workout Screen View Controller
            }
        } else if item == logTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayLogs") as? DisplayLogsScreen{
                navigationController?.pushViewController(nextVC, animated: true) //Push Display Logs Screen View Controller
            }
        }
    }
}
