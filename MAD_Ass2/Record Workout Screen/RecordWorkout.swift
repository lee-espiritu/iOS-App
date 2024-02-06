//
//  RecordWorkoutViewController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//

import UIKit

class RecordWorkout: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
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
        
    }
    

    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishWorkoutButtonPressed(_ sender: Any) {
   
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
    
    var selectedExerciseName: String = ""
    var selectedSet: String = ""
    var selectedRep: String = ""
    var selectedWeight: String = ""
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
