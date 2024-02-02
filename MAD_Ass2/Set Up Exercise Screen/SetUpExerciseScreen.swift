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
    
    var categories: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set background
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        //Add the top navbar
        view.addSubview(CustomNavBar())
 
    }
    
    @IBAction func goBackPressed(_ sender: Any) {
        //pop the stack, assuming that it will always lead to home screen
        navigationController?.popViewController(animated: true)
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
                        }
                    }
                    customCategoryAlert.addAction(customCategoryOKAction)
                    
                    let customCategoryCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    customCategoryAlert.addAction(customCategoryCancelAction)
                    
                    // Present the custom category alert
                    self.present(customCategoryAlert, animated: true, completion: nil)
                } else {
                    self.categoryButton.setTitle("\(selectedOption)", for: .normal)
                }
            } else {
                print("No option selected")
            }
        }
        categoryAlert.addAction(okAction)

        // Present the alert from the current view controller
        present(categoryAlert, animated: true, completion: nil)

    }
    
}
