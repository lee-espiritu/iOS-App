//
//  SetUpExerciseScreen.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//
//  Class Description: Responsible for the set up exercise screen. Handles user inputs in creating an exercise for further use.
//

import UIKit

class SetUpExerciseScreen: UIViewController, UIViewControllerTransitioningDelegate, UITabBarDelegate{
    
    //Reference outlets for the form UI elements
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var saveExerciseButton: UIButton!
    @IBOutlet weak var viewForm: UIView!
    @IBOutlet weak var repetitionsNumber: UIButton!
    @IBOutlet weak var setsNumber: UIButton!
    @IBOutlet weak var weightNumber: UIButton!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var repetitionsStepper: UIStepper!
    @IBOutlet weak var setsStepper: UIStepper!
    @IBOutlet weak var weightSlider: UISlider!
    
    //Tab bar reference outlets
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var exerciseTabBarItem: UITabBarItem!
    @IBOutlet weak var dailyProgramTabBarItem: UITabBarItem!
    @IBOutlet weak var recordTabBarItem: UITabBarItem!
    @IBOutlet weak var logTabBarItem: UITabBarItem!
    
    //Variable to store categories
    var categories: [[String: Any]] = []

    //Default function created on class creation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set background
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        //Add the top navbar
        view.addSubview(CustomNavBar(title: "Set Up Exercise"))
 
        //Required
        tabBar.delegate = self
        
        //Disable save exercise button
        saveExerciseButton.isEnabled = false
        
        // Set rounded corners for the view
        viewForm.layer.cornerRadius = 10
        viewForm.layer.masksToBounds = true

        // Add a glow effect using shadow properties
        viewForm.layer.shadowColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1.0).cgColor
        viewForm.layer.shadowOffset = CGSize.zero
        viewForm.layer.shadowOpacity = 1.0
        viewForm.layer.shadowRadius = 10 // Adjust the radius to control the glow effect
        
        // Add a glow effect using border properties
        viewForm.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 0.7).cgColor
        viewForm.layer.borderWidth = 2 // Adjust the width of the border
    }
    
    //This function updates the save button to be enabled or disabled conditionally
    private func updateSaveButton() {
        if categoryButton.currentTitle == nil || categoryButton.currentTitle!.isEmpty { //If there is no category selected
            saveExerciseButton.isEnabled = false //Disable the Save Exercise button
            return
        }
        if exerciseButton.currentTitle == nil || exerciseButton.currentTitle!.isEmpty { //If there is no exercise selected
            saveExerciseButton.isEnabled = false //Disable the Save Exercise button
            return
        }
        if exerciseButton.currentTitle!.contains("Please select an Exercise ▼") { //If exercise button has been reverted to its default state
            saveExerciseButton.isEnabled = false //Disable the Save Exercise button
            return
        }
        saveExerciseButton.isEnabled = true //Enable the Save Exercise button as it has passed all negative conditions
    }
    
    //Function triggered when 'Go Back' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true) //Return to home screen via root view controller
    }
    
    //Function triggered when the stepper for repetitions is pressed
    //Inputs: @sender - The UIStepper that triggered the function
    @IBAction func repetitionsStepperPressed(_ sender: UIStepper) {
        repetitionsNumber.setTitle(String(Int(sender.value)), for: .normal) //Update the repetitions title to reflect the new value
    }
    
    //Function triggered when the stepper for sets is pressed
    //Inputs: @sender - The UIStepper that triggered the function
    @IBAction func setsStepperPressed(_ sender: UIStepper) {
        setsNumber.setTitle(String(Int(sender.value)), for: .normal) //Update the sets title to reflect the new value
    }
    
    //Function triggered when the slider for weights is changed
    //Inputs: @sender - The UISlider that triggered the function
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        weightNumber.setTitle(String(Int(sender.value)) + " kg", for: .normal) //Update the weights title to reflect the new value
    }
    
    //Function triggered when 'Select Exercise' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func selectExercisePressed(_ sender: Any) {
        //If no category has been selected
        if categoryButton.currentTitle == nil || categoryButton.currentTitle!.isEmpty {
            return //Do nothing
        }
        
        //Create an ExerciseAlertController
        let exerciseAlert = ExerciseAlertController(title: "Select Exercise", message: nil, preferredStyle: .alert)
        
        //Set the custom alert controllers exercise and maxRows variables after searching for existing category and exercises
        exerciseAlert.exercises = DBManager.getExercises(category: categoryButton.currentTitle!)
        exerciseAlert.maxRows = exerciseAlert.exercises.count

        //Add a cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        exerciseAlert.addAction(cancelAction)
        
        //Add a "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // Access the selected option using the method in CategoryAlertController
            if let selectedOption = exerciseAlert.getSelectedOption() { //If there is a selected exercise
                if selectedOption.contains("Custom") {
                    // Create an alert that asks the user to type in a category
                    let customCategoryAlert = UIAlertController(title: "Custom Exercise", message: "Type in an exercise", preferredStyle: .alert)
                    
                    //Insert a textfield for user input
                    customCategoryAlert.addTextField { textField in
                        textField.placeholder = "Category Name"
                    }
                    
                    //Add an ok button with instructions to perform on selection.
                    let customCategoryOKAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
                        if let textField = customCategoryAlert.textFields?.first,
                           let customCategory = textField.text,
                           !customCategory.isEmpty {
                            self?.exerciseButton.setTitle(customCategory, for: .normal)
                            self?.updateSaveButton()
                        }
                    }
                    customCategoryAlert.addAction(customCategoryOKAction)
                    
                    //Add a cancel button
                    let customCategoryCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    customCategoryAlert.addAction(customCategoryCancelAction)
                    
                    // Present the custom category alert
                    self.present(customCategoryAlert, animated: true, completion: nil)
                } else {
                    self.exerciseButton.setTitle("\(selectedOption)", for: .normal)
                    self.updateSaveButton()
                }
            } else {
                print("No option selected")
            }
        }
        exerciseAlert.addAction(okAction)
        
        // Present the alert from the current view controller
        present(exerciseAlert, animated: true, completion: nil)
    }
    
    //Function triggered when 'Select Category' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func selectCategoryPressed(_ sender: Any) {
        //Create a custom CategoryAlertController
        let categoryAlert = CategoryAlertController(title: "Select Category", message: nil, preferredStyle: .alert)

        //Add a cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        categoryAlert.addAction(cancelAction)

        //Add a "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // Access the selected option using the method in CategoryAlertController
            if let selectedOption = categoryAlert.getSelectedOption() { //If a category is selected
                if selectedOption.contains("Custom") { //If custom is chosen
                    //Create another alert that asks the user to type in a category
                    let customCategoryAlert = UIAlertController(title: "Custom Category", message: "Type in a category", preferredStyle: .alert)
                    
                    //Create a textfield for user to type in a new category
                    customCategoryAlert.addTextField { textField in
                        textField.placeholder = "Category Name"
                    }
                    
                    //Set an ok action with instructions on selection
                    let customCategoryOKAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
                        if let textField = customCategoryAlert.textFields?.first,
                           let customCategory = textField.text,
                           !customCategory.isEmpty {
                            // If the user has typed something, set it as the title for categoryButton
                            self?.categoryButton.setTitle(customCategory, for: .normal)
                            self?.exerciseButton.setTitle("Please select an Exercise ▼", for: .normal)
                            self?.updateSaveButton()
                        }
                    }
                    customCategoryAlert.addAction(customCategoryOKAction)
                    
                    //Add a cancel button
                    let customCategoryCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    customCategoryAlert.addAction(customCategoryCancelAction)
                    
                    // Present the custom category alert
                    self.present(customCategoryAlert, animated: true, completion: nil)
                } else {
                    self.categoryButton.setTitle("\(selectedOption)", for: .normal)
                    self.exerciseButton.setTitle("Please select an Exercise ▼", for: .normal)
                    self.updateSaveButton()
                }
            } else {
                print("No option selected")
            }
        }
        categoryAlert.addAction(okAction)

        // Present the alert from the current view controller
        present(categoryAlert, animated: true, completion: nil)

    }
    
    //Function triggered when 'Save Exercise' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func saveExerciseButtonPressed(_ sender: Any) {
        if let categoryTitle = categoryButton.titleLabel?.text,
           let exerciseTitle = exerciseButton.titleLabel?.text {
            //print("Category: \(categoryTitle), Exercise: \(exerciseTitle), Repetitions: \(Int(repetitionsStepper.value)), Sets: \(Int(setsStepper.value)), Weight: \(Int(weightSlider.value))")
            
            //Save the form information to the database
            DBManager.setUpExercise(category: categoryTitle, exercise: exerciseTitle, reps: Int(repetitionsStepper.value), sets: Int(setsStepper.value), weight: Int(weightSlider.value))
        } else {
            print("Category or Exercise title is nil")
            //Do nothing
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
