//
//  SetUpDailyProgram.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 29/1/2024.
//

import UIKit

class SetUpDailyProgramScreen: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var selectedDay: String = ""
    
    struct Exercise {
        let name: String
    }
    
    let data: [Exercise] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set background
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        //Required
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func goBackPressed(_ sender: Any) {
        //pop the stack, assuming that it will always lead to home screen
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If the section is the day section
        if section == 0 {
            return 1
        } else if section == 1 {//Else if the section is the exercises section
            return data.count + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { //If the section is the day cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! ProgramDayCell
            cell.buttonTappedHandler = { title in
                if ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"].contains(title) {
                    self.selectedDay = title
                } else {
                    self.selectedDay = ""
                }
                tableView.reloadData()
            }
            return cell
        } else if indexPath.section == 1 { //Else if the section is the exercises cell
            if indexPath.row == data.count { //If the end of the list is reached
                //Create an additional row for 'Add Exercise'
                let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ProgramExerciseCell
                cell.label.text = "Add Exercise"
                cell.iconImageView.image = UIImage(named: "plus")
                return cell
            } else {
                //Fill existing exercise details
                var exercise: Exercise
                if selectedDay == "" {
                    exercise = data[indexPath.row]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ProgramExerciseCell
                    cell.label.text = exercise.name
                    cell.iconImageView.image = UIImage(named: "plus")
                    return cell
                }
                
            }
        }
        print("ViewController (tableView) : Returning UITableViewCell")
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 80
        } else {
            return 50
        }
    }
}

//
