//
//  SelectDayCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 30/1/2024.
//  Version: 1.0
//  Description: Prototype Cell class
//

import UIKit

class SelectDayCell: UITableViewCell {

    @IBOutlet weak var horizontalScrollView: UIScrollView!
    
    private var selectedButton: UIButton?
    
    // Declare plusButton as a property
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.frame = CGRect(x: 0, y: (horizontalScrollView.frame.height - horizontalScrollView.frame.height*0.75)/2, width: 20, height: horizontalScrollView.frame.height*0.75)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
        // Set border properties
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = button.frame.width / 2.0
        button.layer.borderColor = UIColor.systemBlue.cgColor
            
        
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureHorizontalScrolling()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func configureHorizontalScrolling() {
        // Add "+" button
        horizontalScrollView.addSubview(plusButton)

        // Disable vertical scrolling
        horizontalScrollView.showsVerticalScrollIndicator = false
        horizontalScrollView.showsHorizontalScrollIndicator = true
        horizontalScrollView.isScrollEnabled = true
    }
    
    @objc private func plusButtonTapped() {
        // Handle "+" button tap
        
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
        pickerView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -30).isActive = true
        
        // Add a cancel button
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add an OK button
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Handle the selected day
            let selectedDayIndex = pickerView.selectedRow(inComponent: 0)
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
        var topViewController = UIApplication.shared.windows.first?.rootViewController
        
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        
        return topViewController
    }

    func addNewButton(title: String) {
        // Initialise, create, and set the button titles etc. as newButton
        let newButton = UIButton(type: .system)
        newButton.setTitle(title, for: .normal)
        
        //Add a tap gesture recogniser
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dayTapped(_:)))
        newButton.addGestureRecognizer(tapGesture)

        // Calculate the position of the + button
        let newPosition = CGPoint(x: plusButton.frame.minX, y: (horizontalScrollView.frame.height - horizontalScrollView.frame.height*0.75)/2)
        
        // Position newButton at the + button position
        newButton.frame = CGRect(origin: newPosition, size: CGSize(width: 50, height: horizontalScrollView.frame.height*0.75))
        
        // Set border properties
        newButton.layer.borderWidth = 1.0
        newButton.layer.cornerRadius = newButton.frame.width / 4.0
        newButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        // Add the newButton to the visible area
        horizontalScrollView.addSubview(newButton)
        
        // Move the + button to the right of newButton
        plusButton.frame.origin.x = newButton.frame.maxX + 3
        
        // Update content size
        updateContentSize()
    }
    
    @objc private func dayTapped(_ sender: UITapGestureRecognizer) {
        // Handle button tap
        if let tappedButton = sender.view as? UIButton {
            // Highlight the tapped button
            tappedButton.layer.borderColor = UIColor.systemGreen.cgColor
            tappedButton.layer.borderWidth = 2.0
            
            // Unhighlight the previously selected button
            selectedButton?.layer.borderColor = UIColor.systemBlue.cgColor
            selectedButton?.layer.borderWidth = 1.0
            
            // Update the selectedButton reference
            selectedButton = tappedButton
        }
    }


    private func updateContentSize() {
        let totalWidth = horizontalScrollView.subviews.reduce(0) { $0 + $1.frame.width }
        horizontalScrollView.contentSize = CGSize(width: totalWidth, height: horizontalScrollView.frame.height)
    }
    
    //Public function to round corners
    func roundCorners(corners: UIRectCorner) {
        let cornerRadius: CGFloat = 10
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }


}

extension SelectDayCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 7 // Number of days
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Return the day names (e.g., Monday, Tuesday, etc.)
        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        return days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Handle the selected day, if needed
        // You may update the newButton title or perform any other actions
    }
}
