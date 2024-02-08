//
//  DayPickerAlertController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 8/2/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//
//  Class Description: Custom Alert Controller that allows a user to select a date up to the present.

import UIKit

class DayPickerAlertController: UIAlertController {

    private let datePicker = UIDatePicker()
    private var selectedDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize appearance/behaviour of the alert controller
        configureDatePicker()
    }

    private func configureDatePicker() {
        datePicker.datePickerMode = .date // Configure the date picker to display and allow selection of dates without including the time component.
        datePicker.maximumDate = Date() // Restrict selection to today or earlier

        // Set the initial selected date for the date picker
        datePicker.date = selectedDate // Set the selected date to the previously selected date
        
        // Add the target-action mechanism to handle date changes
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Add the date picker as a subview to the alert controller's content view
        self.view.addSubview(datePicker)

        // Enable autoresizing mask to properly position the date picker
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        // Center the date picker vertically and horizontally in the alert controller's view
        datePicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        datePicker.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        // Adjust the alert controller's height to accommodate the date picker
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        self.view.addConstraint(height)
    }

    // This function updated selectedDate whenever the selection is changed in datePicker
    @objc private func dateChanged() {
        print("Updating selectedDate")
        selectedDate = datePicker.date
    }

    // This function retrieves the value of selectedDate
    func getSelectedDate() -> Date {
        return selectedDate
    }

}
