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

class SetUpExerciseScreen: UIViewController, UIViewControllerTransitioningDelegate{
    
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
    
    var categories: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set background
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        //Add the top navbar
        view.addSubview(CustomNavBar(title: "Set Up Exercise"))
 
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
    
    private func updateSaveButton() {
        if categoryButton.currentTitle == nil || categoryButton.currentTitle!.isEmpty {
            saveExerciseButton.isEnabled = false
            return
        }
        if exerciseButton.currentTitle == nil || exerciseButton.currentTitle!.isEmpty {
            saveExerciseButton.isEnabled = false
            return
        }
        if exerciseButton.currentTitle!.contains("Please select an Exercise ▼") {
            saveExerciseButton.isEnabled = false
            return
        }
        saveExerciseButton.isEnabled = true
    }
    
    @IBAction func goBackPressed(_ sender: Any) {
        //pop the stack, assuming that it will always lead to home screen
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func repetitionsStepperPressed(_ sender: UIStepper) {
        repetitionsNumber.setTitle(String(Int(sender.value)), for: .normal)
    }
    @IBAction func setsStepperPressed(_ sender: UIStepper) {
        setsNumber.setTitle(String(Int(sender.value)), for: .normal)
    }
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        weightNumber.setTitle(String(Int(sender.value)) + " kg", for: .normal)
    }
    @IBAction func selectExercisePressed(_ sender: Any) {
        if categoryButton.currentTitle == nil || categoryButton.currentTitle!.isEmpty {
            return
        }
        
        let exerciseAlert = ExerciseAlertController(title: "Select Exercise", message: nil, preferredStyle: .alert)
        
        exerciseAlert.exercises = DBManager.getExercises(category: categoryButton.currentTitle!)
        exerciseAlert.maxRows = exerciseAlert.exercises.count

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        exerciseAlert.addAction(cancelAction)
        
        // Add the "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // Access the selected option using the method in CategoryAlertController
            if let selectedOption = exerciseAlert.getSelectedOption() {
                print("Selected Option: \(selectedOption)")
                if selectedOption.contains("Custom") {
                    // Another alert that asks the user to type in a category
                    let customCategoryAlert = UIAlertController(title: "Custom Exercise", message: "Type in an exercise", preferredStyle: .alert)
                    
                    customCategoryAlert.addTextField { textField in
                        textField.placeholder = "Category Name"
                    }
                    
                    let customCategoryOKAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
                        if let textField = customCategoryAlert.textFields?.first,
                           let customCategory = textField.text,
                           !customCategory.isEmpty {
                            self?.exerciseButton.setTitle(customCategory, for: .normal)
                            self?.updateSaveButton()
                        }
                    }
                    customCategoryAlert.addAction(customCategoryOKAction)
                    
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
    
    @IBAction func selectCategoryPressed(_ sender: Any) {
        let categoryAlert = CategoryAlertController(title: "Select Category", message: nil, preferredStyle: .alert)

        // Add any custom actions if needed
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        categoryAlert.addAction(cancelAction)

        // Add the "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            // Access the selected option using the method in CategoryAlertController
            if let selectedOption = categoryAlert.getSelectedOption() {
                print("Selected Option: \(selectedOption)")
                if selectedOption.contains("Custom") {
                    // Another alert that asks the user to type in a category
                    let customCategoryAlert = UIAlertController(title: "Custom Category", message: "Type in a category", preferredStyle: .alert)
                    
                    customCategoryAlert.addTextField { textField in
                        textField.placeholder = "Category Name"
                    }
                    
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
    
    @IBAction func saveExerciseButtonPressed(_ sender: Any) {
        if let categoryTitle = categoryButton.titleLabel?.text,
           let exerciseTitle = exerciseButton.titleLabel?.text {

            print("Category: \(categoryTitle), Exercise: \(exerciseTitle), Repetitions: \(Int(repetitionsStepper.value)), Sets: \(Int(setsStepper.value)), Weight: \(Int(weightSlider.value))")
            DBManager.setUpExercise(category: categoryTitle, exercise: exerciseTitle, reps: Int(repetitionsStepper.value), sets: Int(setsStepper.value), weight: Int(weightSlider.value))
        } else {
            print("Category or Exercise title is nil")
        }
    }
}
