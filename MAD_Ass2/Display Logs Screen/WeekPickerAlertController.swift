//
//  WeekPickerAlertController.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 8/2/2024.
//

import UIKit

class WeekPickerAlertController: UIAlertController, UIPickerViewDataSource, UIPickerViewDelegate {

    private let pickerView = UIPickerView()
    private var selectedWeek: Int = 0

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
    
    // Store the selected week when it changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWeek = row
    }

    // Provide a method to get the selected week
    func getSelectedWeek() -> (weekNumber: Int, startDate: Date, endDate: Date) {
        let weekNumber = selectedWeek + 1
        let startDate = Calendar.current.date(byAdding: .day, value: 1, to: getDateForWeek(weekOfYear: weekNumber))! 
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
        return (weekNumber, startDate, endDate)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Adjust the number of components in the picker view
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Return the number of weeks you want to display in the picker view
        return 52 // For example, display 52 weeks in a year
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Customize the content of each row to represent date range for each week
        let startDate = getDateForWeek(weekOfYear: row + 1)
        let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        return "\(startDateString) - \(endDateString)"
    }
    
    private func getDateForWeek(weekOfYear: Int) -> Date {
        var components = DateComponents()
        components.weekOfYear = weekOfYear
        components.weekday = 2 // Monday
        components.yearForWeekOfYear = Calendar.current.component(.yearForWeekOfYear, from: Date())
        return Calendar.current.date(from: components)!
    }

}
