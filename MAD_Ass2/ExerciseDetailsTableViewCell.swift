//
//  ExerciseDetailsTableViewCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 29/1/2024.
//

import UIKit

class ExerciseDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var exerciseCategory: UILabel!
    @IBOutlet weak var exerciseSets: UILabel!
    @IBOutlet weak var exerciseRepetitions: UILabel!
    @IBOutlet weak var exerciseWeight: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        exerciseName.font = exerciseName.font.withSize(12)
        exerciseCategory.font = exerciseCategory.font.withSize(12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
