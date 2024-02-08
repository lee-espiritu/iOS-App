//
//  RecordWorkoutViewController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Class Description: Custom Alert Controller that allows a user to select any from the 52 weeks
//                     Starting at Jan 1 - Jan 7 for week 1.

import UIKit

class RecordWorkout: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    //Reference outlet for tableview
    @IBOutlet weak var tableView: UITableView!
    
    //Tab Bar reference outlets
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var exerciseTabBarItem: UITabBarItem!
    @IBOutlet weak var dailyProgramTabBarItem: UITabBarItem!
    @IBOutlet weak var recordTabBarItem: UITabBarItem!
    @IBOutlet weak var logTabBarItem: UITabBarItem!
    
    //Variables to store user selected exercise, set, rep and weight
    var selectedExerciseName: String = ""
    var selectedSet: String = ""
    var selectedRep: String = ""
    var selectedWeight: String = ""
    
    //Variable to store current day of week
    var dayOfWeek: String = ""
    
    //Variable that stores IndexPath tableview information
    var selectedIndexPath: IndexPath?
    
    //Boolean variable to determine if the user is currently working out
    var isWorkingOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Apply background gradient
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        // Retrieve the day of the week
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let today = Date()
        dayOfWeek = dateFormatter.string(from: today)
        let title = "\(dayOfWeek)'s Workout" //Set the title for the nav bar
        
        //Add the top navbar
        view.addSubview(CustomNavBar(title: title))
        
        //Required
        tableView.dataSource = self
        tableView.delegate = self
        tabBar.delegate = self
        
    }
    
    //Function triggered when 'Go Back' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //Function triggered when 'Finish Workout' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func finishWorkoutButtonPressed(_ sender: Any) {
        guard !isWorkingOut else { return }// Return if it's currently in workout mode

        // Add the days workout into Database WorkoutRecord entity.
        for b in DBManager.getExercisePlan(forDay: dayOfWeek) { //For each row (exercise) in the PlanWorkout
            if let a = DBManager.getDefaultValue(forExercise: b["exerciseName"]!, forCategory: b["categoryName"]!) { //Get the default values
                //print("\(b["exerciseName"]!) \(b["categoryName"]!) \(a.sets) \(a.repetitions) \(a.weight)")
                DBManager.addWorkoutRecord(date: Date(), category: b["categoryName"]!, exercise: b["exerciseName"]!, sets: Int32(a.sets)!, repetitions: Int32(a.repetitions)!, weight: Int32(a.weight)!)
            }
        }
        
        // Show an alert indicating that the workout is saved
        let alertController = UIAlertController(title: "Workout Saved", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true) //Return to previous page when OK is pressed
        }))

        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    //Required function that returns the number of rows for a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isWorkingOut { //Check if the user is working out
            return 1 //Return just 1 row which will show the workout session details
        } else { //Otherwise
            return DBManager.getExercisePlan(forDay: dayOfWeek).count //Show the workout plan for the day
        }
    }
    
    //Required function that defines what types of cells are used for the given indexpath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isWorkingOut { //If the user is working out
            let cell = tableView.dequeueReusableCell(withIdentifier: "recordSession") as! RecordSession //Use the RecordSession TableViewCell subclass
            cell.delegate = self //Set the cell delegate
            
            //Set the texts of the UI elements in the cell
            cell.exerciseLabel.text? = selectedExerciseName
            cell.setLabel.text? = selectedSet
            cell.repLabel.text? = selectedRep
            cell.updateSetsAndRepetitions(setValue: selectedSet, repValue: selectedRep)
            cell.weightLabel.text? = selectedWeight
            
            return cell //Return RecordSession TableViewCell
        } else { //Otherwise
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseList") as! RecordWorkoutTableViewCell //Use the RecordWorkoutTableViewCell subclass
            
            //Set all the UI elements texts and values in the cell.
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
            
            return cell //Return an updated RecordWorkoutTableViewCell
        }
    }
    
    //Function to set the height of prototype cells
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isWorkingOut { //If the user is working out
            //Set the height of the cell as shown in RecordSession storyboard
            let cell = tableView.dequeueReusableCell(withIdentifier: "recordSession") as! RecordSession
            return cell.bounds.height
        } else { //Otherwise
            //Set the height of the cell as shown in RecordWorkoutTableViewCell storyboard
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseList") as! RecordWorkoutTableViewCell
            return cell.bounds.height
        }
    }
    
    //Required function that performs operations based on the cell chosen in the tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isWorkingOut { //If the user is working out
            tableView.deselectRow(at: indexPath, animated: true) //Remove the highlighting for the cell selected
        } else { //Otherwise
            //Use a RecordWorkoutTableViewCell to setup the workout mode the user is about to enter
            if let cell = tableView.cellForRow(at: indexPath) as? RecordWorkoutTableViewCell {
                selectedExerciseName = cell.exerciseLabel.text!
                selectedSet = cell.setNumberLabel.text!
                selectedRep = cell.repetitionNumberLabel.text!
                selectedWeight = cell.weightNumberLabel.text!
            }
            print("User is going into workout mode")
            isWorkingOut = true //Toggle the isWorkingOut variable
            
            tableView.deselectRow(at: indexPath, animated: true) //Remove the highlighting of seleciton

            // Add a small delay or use DispatchQueue to ensure the animation has time to complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Reload data after the deselect animation has finished
                let sectionToReload = 0 // Select the section to reload
                let animation = UITableView.RowAnimation.left // Animate left exit
                tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
            }
        }
    }
    
    // This function handles the selection of each tab bar item and performs navigation actions accordingly.
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Check if the selected item is the homeTabBarItem
        if item == homeTabBarItem {
            navigationController?.popToRootViewController(animated: true) //Pop to home screen which is root view controller
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

extension RecordWorkout: RecordSessionDelegate { //Extend to conform to the RecordSessionDelegate protocol
    // Delegate method called when the quit button is pressed in a RecordSession cell
    func quitButtonPressed(in cell: RecordSession) {
        print("Quit button pressed in RecordSession")
        isWorkingOut = false //Toggle isWorkingOut
        let sectionToReload = 0 // Select the section of the table view to reload
        let animation = UITableView.RowAnimation.right //Right exit animation
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
}
