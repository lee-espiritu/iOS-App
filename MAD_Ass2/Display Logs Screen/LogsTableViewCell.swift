//
//  LogsTableViewCell.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 6/2/2024.
//

import UIKit

class LogsTableViewCell: UITableViewCell {

    var delegate: LogsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        delegate?.didPressTakePhotoButton(in: self)
    }
}

protocol LogsTableViewCellDelegate: AnyObject {
    func didPressTakePhotoButton(in cell: LogsTableViewCell)
}
