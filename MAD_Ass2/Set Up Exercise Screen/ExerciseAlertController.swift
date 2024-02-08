//
//  ExerciseAlertController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 2/2/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Class Description: Custom Alert Controller that allows a user to select an exercise

import UIKit

class ExerciseAlertController: UIAlertController, UIPickerViewDelegate, UIPickerViewDataSource {

    //Variables for the picker view and selection
    private let pickerView = UIPickerView()
    private var selectedRow: Int = 0
    
    //Variables to store exercises and number of rows from the Exercise entity
    var exercises: [String] = []
    var maxRows: Int = 0
    
    //Default function created on class creation
    override func viewDidLoad() {
        super.viewDidLoad()

        //Customize the alert controller
        configurePickerView()
    }
    
    //Function to customise the picker view
    private func configurePickerView() {
        //Set delegate and data source
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Add the picker view as a subview
        self.view.addSubview(pickerView)
        
        // Layout constraints for the picker view
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        pickerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // Adjust the alert controller's height to accommodate the picker view
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        self.view.addConstraint(height)
    }

    //Required function to store the selected row when it changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row //Store selection in selectedRow
    }

    //Function to retrieve the selected option
    func getSelectedOption() -> String? {
        if selectedRow == maxRows { //If the end is reached
            return "Custom" //Set custom option
        } else { //Otherwise
            return exercises[selectedRow] //Set exercise from DB option
        }
    }

    //Required function to set the number of components for the picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //Only 1 component for exercise in this case
    }

    //Required function to set the number of rows per component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxRows + 1 //Number of rows in exercise plus 1 for custom option
    }

    //Function to set the title for the row in the picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == maxRows { //If the index is at the end
            return "Custom" //Set the title to custom
        } else { //otherwise
            return exercises[row] //Set the title to the exercise name
        }
    }

}
