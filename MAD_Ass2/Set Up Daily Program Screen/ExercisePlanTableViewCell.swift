//
//  ExercisePlanTableViewCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//

import UIKit

class ExercisePlanTableViewCell: UITableViewCell {

    
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var exercise: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
