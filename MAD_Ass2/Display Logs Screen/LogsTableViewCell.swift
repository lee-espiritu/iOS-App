//
//  LogsTableViewCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 6/2/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//
//  Class Description: Contains the dynamic prototype cell content within the main tableview in Display Logs Screen

import UIKit

class LogsTableViewCell: UITableViewCell {

    //Cell UI Reference Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var imageSlot: UIImageView!
    
    // Delegate property to handle button actions in the cell
    var delegate: LogsTableViewCellDelegate?
    
    //Default function added on class creation
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //Default function added on class creation
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // This function is called when "Take Photo" button is pressed
    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        delegate?.didPressTakePhotoButton(in: self)  // Notify the delegate that the "Take Photo" button was pressed in this cell
    }
    
    // This function is called when "SMS" button is pressed
    @IBAction func sendSMSButtonPressed(_ sender: Any) {
        delegate?.didPressSendSMSButton(in: self)  // Notify the delegate that the "SMS" button was pressed in this cell
    }
}

// Protocol defining methods to handle button actions in the LogsTableViewCell
protocol LogsTableViewCellDelegate: AnyObject {
    func didPressTakePhotoButton(in cell: LogsTableViewCell) // Method called when the "Take Photo" button is pressed in the cell
    func didPressSendSMSButton(in cell: LogsTableViewCell) // Method called when the "SMS" button is pressed in the cell
}
