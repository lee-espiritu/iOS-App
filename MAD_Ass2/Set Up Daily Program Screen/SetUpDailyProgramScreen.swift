//
//  SetUpDailyProgram.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 29/1/2024.
//

import UIKit

class SetUpDailyProgramScreen: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var exercises: [[String: String]] = []
    var selectedDay: Int = 0
    var dayString: String = ""
    var isSelectingCategory: Bool = false
    var isSelectingExercise: Bool = false
    var categorySelected: String = ""
    var exerciseSelected: String = ""
    
    @IBOutlet weak var saveProgramPlanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set background
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))

        //Add the top navbar
        view.addSubview(CustomNavBar(title: "Set Up Daily Program"))
        
        //Required
        tableView.delegate = self
        tableView.dataSource = self

        //Disable the save program plan button
        saveProgramPlanButton.isEnabled = false
    }

    @IBAction func goBackPressed(_ sender: Any) {
        //pop the stack, assuming that it will always lead to home screen
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func monPressed(_ sender: Any) {
        selectedDay = 1
        dayString = "Monday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func tuePressed(_ sender: Any) {
        selectedDay = 2
        dayString = "Tuesday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func wedPressed(_ sender: Any) {
        selectedDay = 3
        dayString = "Wednesday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func thuPressed(_ sender: Any) {
        selectedDay = 4
        dayString = "Thursday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func friPressed(_ sender: Any) {
        selectedDay = 5
        dayString = "Friday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func satPressed(_ sender: Any) {
        selectedDay = 6
        dayString = "Saturday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func sunPressed(_ sender: Any) {
        selectedDay = 7
        dayString = "Sunday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func saveProgramPlanButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Program Saved", message: nil, preferredStyle: .alert)

        // Cancel button
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //categoryAlert.addAction(cancelAction)

        // Add the "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)

        // Present the alert from the current view controller
        present(alert, animated: true, completion: nil)
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If a day has not yet been selected, show nothing in the tableview
        if selectedDay == 0 {
            return 0
        } else if isSelectingCategory { //Check if the user is in the select category screen
            print("Number of categories: \(DBManager.getNumRows(entityName: "Category"))")
            return DBManager.getNumRows(entityName: "Category")
        } else if isSelectingExercise{
            print("Number of exercises in \(categorySelected): \(DBManager.getNumRows(entityName: "ExerciseCategory", categoryName: categorySelected))")
            return DBManager.getNumRows(entityName: "ExerciseCategory", categoryName: categorySelected)
        } else {
            return exercises.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedDay == 0 {
            return UITableViewCell()
        }
        
        if isSelectingCategory {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
            cell.category.text? = DBManager.getCategory(index: indexPath.row)
            cell.exercise.text? = ""
            return cell
        } else if isSelectingExercise {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
            cell.category.text? = DBManager.getExercise(index: indexPath.row, category: categorySelected)
            cell.exercise.text? = ""
            return cell
        } else {
            if indexPath.row == exercises.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
                if exercises.count < 6 {
                    cell.category.text? = "Select \(6 - exercises.count) more exercise"
                } else {
                    cell.category.text? = "Optional: Add more exercise"
                }
                cell.exercise.text? = ""
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
                cell.category.text? = DBManager.getExercisePlan(forDay: dayString)[indexPath.row]["categoryName"]!
                cell.exercise.text? = DBManager.getExercisePlan(forDay: dayString)[indexPath.row]["exerciseName"]!
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan") as! ExercisePlanTableViewCell
        return cell.bounds.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedDay == 0 {
            return
        }
        
        if isSelectingCategory {
            print("Selected \(DBManager.getCategory(index: indexPath.row))")
            categorySelected = DBManager.getCategory(index: indexPath.row)
            isSelectingCategory = false
            isSelectingExercise = true
            tableView.reloadData()
        } else if isSelectingExercise {
            print("Selected \(DBManager.getExercise(index: indexPath.row, category: categorySelected))")
            exerciseSelected = DBManager.getExercise(index: indexPath.row, category: categorySelected)
            isSelectingExercise = false
            isSelectingCategory = false
            
            //Add selection to DB
            DBManager.addRowPlanWorkout(day: selectedDay, exerciseName: exerciseSelected, categoryName: categorySelected)
            
            //Update exercises as it will be used immediately to display changes
            exercises = DBManager.getExercisePlan(forDay: dayString)
            
            //Update the save program button if validation is met
            if DailyProgramValidationManager.isValidProgram() {
                saveProgramPlanButton.isEnabled = true
            }
            
            print("Reloading Data")
            tableView.reloadData()
        } else {
            //If the user has opted to select more exercises
            if indexPath.row == exercises.count {
                print("Selected 'Select X more exercise' cell")
                isSelectingCategory = true
                tableView.reloadData()
            } else {
                print("Selected regular cell at row \(indexPath.row)")
            }
        }

        // Deselect the row to remove the highlight
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
