//
//  RecordWorkoutTableViewCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Class Description: Contains the dynamic prototype cell content within the main tableview in Record Workout Screen

import UIKit

class RecordWorkoutTableViewCell: UITableViewCell {
    
    //Cell UI Reference Outlets
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var repetitionNumberLabel: UILabel!
    @IBOutlet weak var weightNumberLabel: UILabel!
    @IBOutlet weak var setStepper: UIStepper!
    @IBOutlet weak var repetitionStepper: UIStepper!
    @IBOutlet weak var weightSlider: UISlider!
    
    //Default function added on class creation
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editCellAppearance()
    }
    
    //Default function added on class creation
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Function to edit the table view cells UI appearance
    private func editCellAppearance() {
        // Set the background color of the cell to clear
        backgroundColor = .clear
        
        // Set rounding to the corners
        layer.cornerRadius = 10
        
        // Create a bottom border
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1) // Adjust the height as needed
        bottomBorder.backgroundColor = UIColor.cyan.cgColor // Set the color of the bottom border
        
        // Add the bottom border to the cell's layer
        layer.addSublayer(bottomBorder)
        
        // Create a custom background gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 5, width: frame.size.width, height: frame.size.height - 10)
        gradientLayer.colors = [UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.3).cgColor, UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.3).cgColor] // Set gradient colors with lighter alpha component
        gradientLayer.cornerRadius = 5 // Set rounding to the corners
        layer.insertSublayer(gradientLayer, at: 0) // Add the gradient layer below other layers
        

    }
    
    //Function triggered when - or + on the stepper is pressed, updates repetitionNumberlabel.text
    //Inputs: @sender - The UIStepper that triggered the function
    @IBAction func repetitionsStepperPressed(_ sender: UIStepper) {
        repetitionNumberLabel.text = String(Int(sender.value)) //Update the repetition label to the new value
    }
    
    //Function triggered when - or + on the stepper is pressed, updates setNumberLabel.text
    //Inputs: @sender - The UIStepper that triggered the function
    @IBAction func setsStepperPressed(_ sender: UIStepper) {
        setNumberLabel.text = String(Int(sender.value)) //Update the set label to the new value
    }
    
    //Function triggered when the value of the referenced UISlider changes
    //Inputs: @sender - The UISlider that triggered the function
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        weightNumberLabel.text = "\(String(Int(sender.value))) kg" //Update the weight label to the new slider value
    }
    
    //Function triggered when 'Save' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func saveButtonPressed(_ sender: Any) {
        //Update the users workout changes to the database
        DBManager.updateDefaultExercise(exerciseName: exerciseLabel.text!, categoryName: categoryLabel.text!, sets: Int(setStepper.value), repetitions: Int(repetitionStepper.value), weight: Int(weightSlider.value))
        //print("Updated workout!")
    }
}
