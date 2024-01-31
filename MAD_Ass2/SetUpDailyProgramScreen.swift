//
//  SetUpDailyProgram.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 29/1/2024.
//

import UIKit

class SetUpDailyProgramScreen: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "day1Cell", for: indexPath) as! SelectDayCell
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "day1Cell", for: indexPath) as! SelectDayCell
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.leftLabel?.text = "Select Day 1"
                cell.rightLabel?.text = "---------"
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.leftLabel?.text = "Select Exercise"
                cell.rightLabel?.text = "---------"
                cell.accessoryType = .disclosureIndicator
            }
        case 1:
            if indexPath.row == 0 {
                cell.leftLabel?.text = "Select Day 2"
                cell.rightLabel?.text = "---------"
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.leftLabel?.text = "Select Exercise"
                cell.rightLabel?.text = "---------"
                cell.accessoryType = .disclosureIndicator
            }
        case 2:
            if indexPath.row == 0 {
                cell.leftLabel?.text = "Select Day 3"
                cell.rightLabel?.text = "---------"
                cell.accessoryType = .disclosureIndicator
            } else if indexPath.row == 1 {
                cell.leftLabel?.text = "Select Exercise"
                cell.rightLabel?.text = "---------"
                cell.accessoryType = .disclosureIndicator
            }
        default:
            break
        }
        
        return cell
    }
     */
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let customCell = cell as? SelectDayCell else {
                return
            }

            let totalRowsInSection = tableView.numberOfRows(inSection: indexPath.section)

            if indexPath.row == 0 {
                // First row, round top corners
                customCell.roundCorners(corners: [.topLeft, .topRight])
            } else if indexPath.row == totalRowsInSection - 1 {
                // Last row, round bottom corners
                customCell.roundCorners(corners: [.bottomLeft, .bottomRight])
            } else {
                // Middle rows, reset corners
                customCell.roundCorners(corners: [])
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Specify the height for the header (gap) between sections
        return 10.0
    }
    

    @IBOutlet weak var dayExerciseTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set background
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        //Clear the background colour ofthe tableview
        dayExerciseTableView.backgroundColor = UIColor.clear
        
        //Set the delegate
        dayExerciseTableView.delegate = self
    }

    @IBAction func goBackPressed(_ sender: Any) {
        //pop the stack, assuming that it will always lead to home screen
        navigationController?.popViewController(animated: true)
    }
    

}
