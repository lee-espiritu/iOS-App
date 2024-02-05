//
//  RecordSession.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//

import UIKit

protocol RecordSessionDelegate: AnyObject {
    func quitButtonPressed(in cell: RecordSession)
}

class RecordSession: UITableViewCell {

    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    weak var delegate: RecordSessionDelegate?
    
    var intervalTimer: Int = 5
    var restTimer: Int = 10
    var repetitions: Int = 0
    var sets: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func restButtonPressed(_ sender: Any) {
    }
    @IBAction func startButtonPressed(_ sender: Any) {
    }
    @IBAction func stopButtonPressed(_ sender: Any) {
    }
    @IBAction func quitButtonPressed(_ sender: Any) {
        delegate?.quitButtonPressed(in: self)
    }
}
