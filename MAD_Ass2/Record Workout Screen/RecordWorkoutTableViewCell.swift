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
    }
    
    //Default function added on class creation
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
