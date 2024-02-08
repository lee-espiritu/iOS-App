//
//  MonthPickerAlertController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 8/2/2024.
//

import UIKit

class MonthPickerAlertController: UIAlertController, UIPickerViewDataSource, UIPickerViewDelegate {

    private let pickerView = UIPickerView()
    private var selectedMonth: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize the appearance or behavior of the alert controller
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
    
    // Store the selected month when it changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMonth = row
    }

    // Provide a method to get the selected month
    func getSelectedMonth() -> Int {
        return selectedMonth + 1 // Adding 1 to match month numbers (January is 1)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Adjust the number of components in the picker view
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12 // Return the number of months (January to December)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Customize the content of each row to represent month names
        let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return monthNames[row]
    }

}
