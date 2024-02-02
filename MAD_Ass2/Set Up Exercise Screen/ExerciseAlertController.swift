//
//  ExerciseAlertController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 2/2/2024.
//

import UIKit

class ExerciseAlertController: UIAlertController, UIPickerViewDelegate, UIPickerViewDataSource {

    private let pickerView = UIPickerView()
    private var selectedRow: Int = 0
    var exercises: [String] = []
    var maxRows: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurePickerView()
    }
    
    private func configurePickerView() {
        // Customize your picker view with data or other settings
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Add the picker view as a subview to the alert controller's content view
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

    // Store the selected row when it changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }

    // Provide a method to get the selected option
    func getSelectedOption() -> String? {
        if selectedRow == maxRows {
            return "Custom"
        } else {
            return exercises[selectedRow]
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Adjust the number of components in the picker view
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxRows + 1 // Adjust the number of rows in the picker view
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == maxRows {
            return "Custom"
        } else {
            return exercises[row]
        }
    }

}
