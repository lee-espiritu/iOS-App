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

class SetUpExerciseScreen: UIViewController, UIViewControllerTransitioningDelegate, UIPickerViewDataSource, UIPickerViewDelegate {


    @IBOutlet weak var exerciseDisplay: UILabel!
    @IBOutlet weak var categoryDisplay: UILabel!
    @IBOutlet weak var dynamicPickerView: UIPickerView!
    
    
    @IBOutlet weak var repetitionsStepper: UIStepper!
    @IBOutlet weak var repetitionsLabel: UILabel!
    @IBOutlet weak var confirmRepetitionsButton: UIButton!
    
    
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var setsStepper: UIStepper!
    @IBOutlet weak var confirmSetsButton: UIButton!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var confirmWeightButton: UIButton!
    
    @IBOutlet weak var saveExerciseButton: UIButton!
    
    
    @IBOutlet weak var editCategoryButton: UIButton!
    @IBOutlet weak var editExerciseButton: UIButton!
    @IBOutlet weak var editRepetitionsButton: UIButton!
    @IBOutlet weak var editSetsButton: UIButton!
    @IBOutlet weak var editWeightButton: UIButton!
    
    
    var categories: [String] = []
    var exercises: [(name: String, category: String)] = []
    var repetitions: Int = 0
    var sets: Int = 0
    var weight: Int = 0
    
    var categorySelected: Bool = false
    var exerciseSelected: Bool = false
    var repetitionsSelected: Bool = false
    var setsSelected: Bool = false
    var initialWeightSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set background
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        //
        dynamicPickerView.dataSource = self
        dynamicPickerView.delegate = self
        
        //Load categories
        loadCategories()
        
        //Hide further steps until they're due for prompt
        exerciseDisplay.isHidden = true
        repetitionsLabel.isHidden = true
        repetitionsStepper.isHidden = true;
        confirmRepetitionsButton.isHidden = true;
        setsLabel.isHidden = true;
        setsStepper.isHidden = true;
        confirmSetsButton.isHidden = true;
        weightLabel.isHidden = true;
        weightSlider.isHidden = true;
        confirmWeightButton.isHidden = true;
        saveExerciseButton.isEnabled = false;
        editCategoryButton.isHidden = true;
        editExerciseButton.isHidden = true;
        editRepetitionsButton.isHidden = true;
        editSetsButton.isHidden = true;
        editWeightButton.isHidden = true;
    }

    //This function grabs categories from the database and prepares the contents for selection at the pickerView
    func loadCategories() {
        //Retrieve categories from database
        categories = DBManager.retrieveCategories()
        //Update pickerView with categories
        dynamicPickerView.reloadAllComponents()
    }
    
    //This function grabs exercises from the database and prepares the contents for selection at the pickerView
    func loadExercises(forCategory category: String){
        //Retrieve exercises from database matching the category content
        exercises = DBManager.retrieveExercises().filter { exercise in return exercise.category == category}
        //Update pickerView with exercises
        dynamicPickerView.reloadAllComponents()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if !categorySelected {
            return categories.count + 1 // +1 allows users to add their own custom categories
        } else {
            return exercises.count + 1  // +1 allows users to add their own custom exercise
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Check if the user has yet to select a category
        if !categorySelected{
            if row == categories.count {
                //Display Custom as the last option in pickerView
                return "Custom"
            } else {
                //Display the category name from database
                return categories[row]
            }
        } else {
            if row == exercises.count {
                //Display Custom as the last option in pickerView
                return "Custom"
            } else {
                //Display the exercise name from database
                return exercises[row].name
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dynamicPickerView {
            if !categorySelected {
                if row != categories.count {
                    exerciseDisplay.isHidden = false
                    categoryDisplay.text = categories[row]
                    categorySelected = true
                    //Load exercises from the selected category
                    loadExercises(forCategory: categories[row])
                } else {
                    //Do custom user additions here
                    showCustomCategoryAlert()
                }
            } else if !exerciseSelected {
                if row != exercises.count {
                    exerciseDisplay.text = exercises[row].name
                    exerciseSelected = true
                    dynamicPickerView.isHidden = true
                    repetitionsStepper.isHidden = false
                    repetitionsLabel.isHidden = false
                    confirmRepetitionsButton.isHidden = false
                } else {
                    showCustomExercisesAlert()
                }
            }
        }
    }
    
    func showCustomCategoryAlert() {
        let alert = UIAlertController(title: "Add custom category", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter category name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                guard let textField = alert.textFields?.first, let categoryName = textField.text, !categoryName.isEmpty else {
                    return
                }

                // Update categoryDisplay.text and reload data
                self?.categoryDisplay.text = categoryName
                self?.exerciseDisplay.isHidden = false
                self?.categorySelected = true
                self?.loadExercises(forCategory: categoryName)
                self?.dynamicPickerView.reloadAllComponents()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    func showCustomExercisesAlert() {
        let alert = UIAlertController(title: "Add custom exercise", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter exercise name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                guard let textField = alert.textFields?.first, let exerciseName = textField.text, !exerciseName.isEmpty else {
                    return
                }

                // Update exerciseDisplay.text and proceed to rep/set/weights
                self?.exerciseDisplay.text = exerciseName
                self?.exerciseSelected = true
                self?.dynamicPickerView.isHidden = true
                self?.repetitionsStepper.isHidden = false
                self?.repetitionsLabel.isHidden = false
                self?.confirmRepetitionsButton.isHidden = false
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    
    
    @IBAction func goBackPressed(_ sender: Any) {
        //pop the stack, assuming that it will always lead to home screen
        navigationController?.popViewController(animated: true)
    }

    @IBAction func confirmRepetitions(_ sender: Any) {
        //Set the repetitions
        repetitions = Int(repetitionsStepper.value)
        
        //Hide UI for repetitions
        repetitionsStepper.isHidden = true
        confirmRepetitionsButton.isHidden = true
        repetitionsSelected = true
        
        //Show UI for sets
        setsLabel.isHidden = false
        setsStepper.isHidden = false
        confirmSetsButton.isHidden = false
    }
    
    @IBAction func updateRepetitions(_ sender: UIStepper) {
        //Update the repetitions label to the value of the repetitions stepper
        repetitionsLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func updateSets(_ sender: UIStepper) {
        //Update the sets Label to the value of the set stepper
        setsLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func confirmSets(_ sender: Any) {
        //Set the sets
        sets = Int(repetitionsStepper.value)
        
        //Hide UI for sets
        setsStepper.isHidden = true
        confirmSetsButton.isHidden = true
        setsSelected = true
        
        //Show UI for Weight
        weightLabel.isHidden = false
        weightSlider.isHidden = false
        confirmWeightButton.isHidden = false;
    }
    
    @IBAction func updateWeight(_ sender: UISlider) {
        //Set weightLabel's text value to be the value of the slider
        weightLabel.text = "\(Int(sender.value)) kg"
    }
    
    @IBAction func confirmWeight(_ sender: Any) {
        //Set the weight
        weight = Int(weightSlider.value)
        
        //Hide UI for weight
        weightSlider.isHidden = true;
        confirmWeightButton.isHidden = true;
        initialWeightSelected = true;
        
        //Enable the save exercise button
        saveExerciseButton.isEnabled = true
        
        //Show the edit buttons for all sections
        editCategoryButton.isHidden = false;
        editExerciseButton.isHidden = false;
        editRepetitionsButton.isHidden = false;
        editSetsButton.isHidden = false;
        editWeightButton.isHidden = false;
    }
    
    
    @IBAction func saveExerciseButtonPressed(_ sender: Any) {
        //Check if the category exists
        if DBManager.categoryExists(category: categoryDisplay.text!) {
            print("\(categoryDisplay.text!) exists in the database under Categories table")
        } else {
            print("\(categoryDisplay.text!) does not exist in the database under Categories table")
            DBManager.addCategory(categoryName: categoryDisplay.text!)
        }
        
        //Check if the exercise exists
        if DBManager.exerciseExists(exercise: exerciseDisplay.text!, exerciseCategory: categoryDisplay.text!) {
            print("\(exerciseDisplay.text!) exists in the database under Exercises table with category \(categoryDisplay.text!)")
        } else {
            print("\(exerciseDisplay.text!) does not exist in the database under Exercises table with category \(categoryDisplay.text!)")
            DBManager.addExercise(exerciseName: exerciseDisplay.text!, exerciseCategory: categoryDisplay.text!)
        }
        
        //Notify User that exercise has been saved
        let alert = UIAlertController(title: "Exercise Saved", message: "Your exercise has been successfully saved.", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Return to the home screen or perform any other action
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}
