//
//  DayPickerAlertController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 8/2/2024.
//

import UIKit

class DayPickerAlertController: UIAlertController {

    private let datePicker = UIDatePicker()
    private var selectedDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the appearance or behavior of the alert controller
        configureDatePicker()
    }

    private func configureDatePicker() {
        // Customize your date picker with any settings
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date() // Restrict selection to today or earlier

        // Set the initial selected date for the date picker
        datePicker.date = selectedDate // Set the selected date to the previously selected date
        
        // Add the target-action mechanism to handle date changes
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Add the date picker as a subview to the alert controller's content view
        self.view.addSubview(datePicker)

        // Enable autoresizing mask to properly position the date picker
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        // Center the date picker vertically in the alert controller's view
        datePicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        // Adjust the alert controller's height to accommodate the date picker
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        self.view.addConstraint(height)
    }

    // Store the selected date when it changes
    @objc private func dateChanged() {
        print("Updating selectedDate")
        selectedDate = datePicker.date
    }

    // Provide a method to get the selected date
    func getSelectedDate() -> Date {
        return selectedDate
    }

}
