//
//  DayTableViewCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 31/1/2024.
//

import UIKit

class ProgramDayCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var horizontalScrollView: UIScrollView!
    @IBOutlet weak var addDayButton: UIButton!
    
    private var selectedButton: UIButton?
    var buttonTappedHandler: ((String) -> Void)?
    
    let days: [String] = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureHorizontalScrolling()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureHorizontalScrolling() {
        // Disable vertical scrolling
        horizontalScrollView.showsVerticalScrollIndicator = false
        horizontalScrollView.showsHorizontalScrollIndicator = true
        horizontalScrollView.isScrollEnabled = true
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        // Create a UIPickerView
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Create an alert controller
        let alertController = UIAlertController(title: "Select day", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        // Add the UIPickerView to the alert controller
        alertController.view.addSubview(pickerView)
        
        // Add constraints to set the UIPickerView's width and position
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 8).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -8).isActive = true
        pickerView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 20).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -50).isActive = true
        
        // Add a cancel button
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add an OK button
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Handle the selected day
            let selectedDayIndex = pickerView.selectedRow(inComponent: 0)
            print(selectedDayIndex)
            switch selectedDayIndex {
                case 0:
                    self.addNewButton(title: "MON")
                case 1:
                    self.addNewButton(title: "TUE")
                case 2:
                    self.addNewButton(title: "WED")
                case 3:
                    self.addNewButton(title: "THU")
                case 4:
                    self.addNewButton(title: "FRI")
                case 5:
                    self.addNewButton(title: "SAT")
                case 6:
                    self.addNewButton(title: "SUN")
                default:
                    break
            }
             
            
        }))
        
        // Present the alert controller
        if let viewController = self.getTopMostViewController() {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }

    func getTopMostViewController() -> UIViewController? {
        // Use the connected scenes to find the appropriate UIWindowScene
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
            let window = windowScene.windows.first {
            
            // Start from the root view controller of the main window
            var topViewController = window.rootViewController
            
            // Traverse the presented view controllers
            while let presentedViewController = topViewController?.presentedViewController {
                topViewController = presentedViewController
            }
            
            return topViewController
        }
        
        // Return nil if no suitable window scene is found
        return nil
    }

    func addNewButton(title: String) {
        // Initialise, create, and set the button titles etc. as newButton
        let newButton = UIButton(type: .system)
        newButton.setTitle(title, for: .normal)
        
        //Add a tap gesture recogniser
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayTapped(_:)))
        newButton.addGestureRecognizer(tapGesture)

        // Calculate the position of the + button
        let newPosition = CGPoint(x: addDayButton.frame.minX, y: (horizontalScrollView.frame.height - horizontalScrollView.frame.height*0.75)/2)
        
        // Position newButton at the + button position
        newButton.frame = CGRect(origin: newPosition, size: CGSize(width: 50, height: horizontalScrollView.frame.height*0.75))
        
        // Set border properties
        newButton.layer.borderWidth = 1.0
        newButton.layer.cornerRadius = newButton.frame.width / 4.0
        newButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        // Add the newButton to the visible area
        horizontalScrollView.addSubview(newButton)
        
        // Move the + button to the right of newButton
        addDayButton.frame.origin.x = newButton.frame.maxX + 3
        
        // Update content size
        updateContentSize()
    }
    
    
    @objc private func dayTapped(_ sender: UITapGestureRecognizer) {
        // Handle button tap
        if let tappedButton = sender.view as? UIButton {
            // Unhighlight the previously selected button
            selectedButton?.layer.borderColor = UIColor.systemBlue.cgColor
            selectedButton?.layer.borderWidth = 1.0
            
            // Highlight the tapped button
            tappedButton.layer.borderColor = UIColor.systemGreen.cgColor
            tappedButton.layer.borderWidth = 2.0
            
            // Update the selectedButton reference
            selectedButton = tappedButton
            
            buttonTappedHandler?((tappedButton.titleLabel?.text)!)
        }
    }
    
    private func updateContentSize() {
        let totalWidth = horizontalScrollView.subviews.reduce(0) { $0 + $1.frame.width }
        horizontalScrollView.contentSize = CGSize(width: totalWidth, height: horizontalScrollView.frame.height)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
}
