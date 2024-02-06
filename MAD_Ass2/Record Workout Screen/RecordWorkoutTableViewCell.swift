//
//  RecordWorkoutTableViewCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//

import UIKit

class RecordWorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var repetitionNumberLabel: UILabel!
    @IBOutlet weak var weightNumberLabel: UILabel!
    @IBOutlet weak var setStepper: UIStepper!
    @IBOutlet weak var repetitionStepper: UIStepper!
    @IBOutlet weak var weightSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func repetitionsStepperPressed(_ sender: UIStepper) {
        repetitionNumberLabel.text = String(Int(sender.value))
    }
    @IBAction func setsStepperPressed(_ sender: UIStepper) {
        setNumberLabel.text = String(Int(sender.value))
    }
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        weightNumberLabel.text = "\(String(Int(sender.value))) kg"
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        DBManager.updateDefaultExercise(exerciseName: exerciseLabel.text!, categoryName: categoryLabel.text!, sets: Int(setStepper.value), repetitions: Int(repetitionStepper.value), weight: Int(weightSlider.value))
        print("Updated workout!")
    }
}
