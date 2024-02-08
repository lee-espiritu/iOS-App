//
//  RecordWorkoutViewController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//

import UIKit

class RecordWorkout: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //Tab Bar reference outlets
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var exerciseTabBarItem: UITabBarItem!
    @IBOutlet weak var dailyProgramTabBarItem: UITabBarItem!
    @IBOutlet weak var recordTabBarItem: UITabBarItem!
    @IBOutlet weak var logTabBarItem: UITabBarItem!
    
    var selectedExerciseName: String = ""
    var selectedSet: String = ""
    var selectedRep: String = ""
    var selectedWeight: String = ""
    
    var dayOfWeek: String = ""
    var selectedIndexPath: IndexPath?
    var isWorkingOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Apply background gradient
        //GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        // Retrieve the day of the week
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let today = Date()
        dayOfWeek = dateFormatter.string(from: today)
        let title = "\(dayOfWeek)'s Workout"
        
        //Add the top navbar
        view.addSubview(CustomNavBar(title: title))
        
        //Required
        tableView.dataSource = self
        tableView.delegate = self
        tabBar.delegate = self
        
    }
    

    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishWorkoutButtonPressed(_ sender: Any) {
        //Retrieve all cell.exerciseLabel.text? and print them
        guard !isWorkingOut else { return }// Return if it's currently in workout mode

        // Print the information for the days exercises
        for b in DBManager.getExercisePlan(forDay: dayOfWeek) {
            if let a = DBManager.getDefaultValue(forExercise: b["exerciseName"]!, forCategory: b["categoryName"]!) {
                print("\(b["exerciseName"]!) \(b["categoryName"]!) \(a.sets) \(a.repetitions) \(a.weight)")
                DBManager.addWorkoutRecord(date: Date(), category: b["categoryName"]!, exercise: b["exerciseName"]!, sets: Int32(a.sets)!, repetitions: Int32(a.repetitions)!, weight: Int32(a.weight)!)
            }
        }
        
        // Show an alert indicating that the workout is saved
        let alertController = UIAlertController(title: "Workout Saved", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Pop the view controller
            self.navigationController?.popViewController(animated: true)
        }))

        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isWorkingOut {
            return 1
        } else {
            return DBManager.getExercisePlan(forDay: dayOfWeek).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isWorkingOut {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recordSession") as! RecordSession
            cell.delegate = self
            cell.exerciseLabel.text? = selectedExerciseName
            cell.setLabel.text? = selectedSet
            cell.repLabel.text? = selectedRep
            cell.updateSetsAndRepetitions(setValue: selectedSet, repValue: selectedRep)
            cell.weightLabel.text? = selectedWeight
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseList") as! RecordWorkoutTableViewCell
            cell.exerciseLabel.text? = DBManager.getExercisePlan(forDay: dayOfWeek, index: indexPath.row)!.exerciseName
            cell.categoryLabel.text? = DBManager.getExercisePlan(forDay: dayOfWeek, index: indexPath.row)!.categoryName
            cell.setNumberLabel.text? = DBManager.getDefaultValue(forExercise: cell.exerciseLabel.text!, forCategory: cell.categoryLabel.text!)!.sets
            cell.setStepper.minimumValue = 1 //Cannot have 0 sets
            cell.setStepper.maximumValue = 20
            cell.setStepper.value = Double(cell.setNumberLabel.text!)!
            cell.repetitionNumberLabel.text? = DBManager.getDefaultValue(forExercise: cell.exerciseLabel.text!, forCategory: cell.categoryLabel.text!)!.repetitions
            cell.repetitionStepper.minimumValue = 0 //Cannot have 0 repetitions
            cell.repetitionStepper.maximumValue = 10
            cell.repetitionStepper.value = Double(cell.repetitionNumberLabel.text!)!
            cell.weightNumberLabel.text? = "\(DBManager.getDefaultValue(forExercise: cell.exerciseLabel.text!, forCategory: cell.categoryLabel.text!)!.weight) kg"
            cell.weightSlider.minimumValue = 0
            cell.weightSlider.maximumValue = 200
            cell.weightSlider.value = Float(DBManager.getDefaultValue(forExercise: cell.exerciseLabel.text!, forCategory: cell.categoryLabel.text!)!.weight)!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isWorkingOut {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recordSession") as! RecordSession
            return cell.bounds.height
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseList") as! RecordWorkoutTableViewCell
            return cell.bounds.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isWorkingOut {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            if let cell = tableView.cellForRow(at: indexPath) as? RecordWorkoutTableViewCell {
                selectedExerciseName = cell.exerciseLabel.text!
                selectedSet = cell.setNumberLabel.text!
                selectedRep = cell.repetitionNumberLabel.text!
                selectedWeight = cell.weightNumberLabel.text!
            }
            print("User is going into workout mode")
            isWorkingOut = true
            
            tableView.deselectRow(at: indexPath, animated: true)

            // Add a small delay or use DispatchQueue to ensure the animation has time to complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Reload data after the deselect animation has finished
                let sectionToReload = 0 // Select the section to reload
                let animation = UITableView.RowAnimation.left // Choose the animation type you prefer
                tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
            }
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Check if the selected item is the homeTabBarItem
        if item == homeTabBarItem {
            navigationController?.popToRootViewController(animated: true)
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

extension RecordWorkout: RecordSessionDelegate {
    func quitButtonPressed(in cell: RecordSession) {
        print("Quit button pressed in RecordSession")
        isWorkingOut = false

        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.right // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)

    }
}
