//
//  ViewDatabaseScreen.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//  Version: 1.0
//  Description: This class is responsible for handling the contents of the ViewDatabaseScreen
//

import UIKit

class ViewDatabaseScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var category: [[String: Any]] = []
    var exercise: [[String: Any]] = []
    var exerciseCategory: [[String: Any]] = []
    var defaultExercise: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Required
        tableView.delegate = self
        tableView.dataSource = self
        
        //Apply background gradient
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        //Add the top navbar
        view.addSubview(CustomNavBar(title: "View Database"))
        
        
        reloadData()
    }
    
    func reloadData(){
        tableView.reloadData()
        
        category = DBManager.getAllRows(entityName: "Category")
        exercise = DBManager.getAllRows(entityName: "Exercise")
        exerciseCategory = DBManager.getAllRows(entityName: "ExerciseCategory")
        defaultExercise = DBManager.getAllRows(entityName: "DefaultExercise")
    }


    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func prefillDBPressed(_ sender: Any) {
        DBManager.prefillCategories()
        DBManager.prefillExercises()
        DBManager.prefillExerciseCategory()
        DBManager.prefillDefaultExercise()
        reloadData()
    }
    
    @IBAction func deleteDBPressed(_ sender: Any) {
        DBManager.deleteAllRows(entityName: "Category")
        DBManager.deleteAllRows(entityName: "Exercise")
        DBManager.deleteAllRows(entityName: "ExerciseCategory")
        DBManager.deleteAllRows(entityName: "DefaultExercise")
        DBManager.deleteAllRows(entityName: "PlanWorkout")
        DBManager.deleteAllRows(entityName: "WorkoutRecord")
        DBManager.deleteAllRows(entityName: "Photos")
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return DBManager.getNumRows(entityName: "Category")
        case 1:
            return DBManager.getNumRows(entityName: "Exercise")
        case 2:
            return DBManager.getNumRows(entityName: "ExerciseCategory")
        case 3:
            return DBManager.getNumRows(entityName: "DefaultExercise")
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            //print(category[indexPath.row])
            let cell = UITableViewCell()
            cell.textLabel?.text = category[indexPath.row]["name"] as? String
            return cell
        } else if indexPath.section == 1 {
            //print(exercise[indexPath.row])
            let cell = UITableViewCell()
            cell.textLabel?.text = exercise[indexPath.row]["name"] as? String
            return cell
        } else if indexPath.section == 2 {
            //print(exerciseCategory[indexPath.row])
            let cell = UITableViewCell()
            let nameLabel = UILabel()
            nameLabel.text = exerciseCategory[indexPath.row]["exerciseName"] as? String
            nameLabel.frame = CGRect(x: 180, y: 10, width: 150, height: 30)
            cell.contentView.addSubview(nameLabel)
            
            let categoryLabel = UILabel()
            categoryLabel.text = exerciseCategory[indexPath.row]["categoryName"] as? String
            categoryLabel.frame =   CGRect(x: 20, y: 10, width: 150, height: 30)
            cell.contentView.addSubview(categoryLabel)
            return cell
        } else if indexPath.section == 3 {
            print(defaultExercise[indexPath.row])
            let cell = UITableViewCell()

            let categoryLabel = UILabel()
            categoryLabel.text = defaultExercise[indexPath.row]["categoryName"] as? String
            categoryLabel.frame = CGRect(x: 20, y: 10, width: 60, height: 30)
            categoryLabel.font = UIFont.systemFont(ofSize: 12)
            cell.contentView.addSubview(categoryLabel)

            let exerciseLabel = UILabel()
            exerciseLabel.text = defaultExercise[indexPath.row]["exerciseName"] as? String
            exerciseLabel.frame = CGRect(x: 90, y: 10, width: 120, height: 30)
            exerciseLabel.font = UIFont.systemFont(ofSize: 12)
            cell.contentView.addSubview(exerciseLabel)

            let setsLabel = UILabel()
            if let setsValue = defaultExercise[indexPath.row]["sets"] as? Int {
                setsLabel.text = String(setsValue)
            } else {
                setsLabel.text = "N/A"
            }
            setsLabel.frame = CGRect(x: 220, y: 10, width: 30, height: 30)  // Adjusted position and width
            cell.contentView.addSubview(setsLabel)

            let repetitionsLabel = UILabel()
            if let repetitionsValue = defaultExercise[indexPath.row]["repetitions"] as? Int {
                repetitionsLabel.text = String(repetitionsValue)
            } else {
                repetitionsLabel.text = "N/A"
            }
            repetitionsLabel.frame = CGRect(x: 260, y: 10, width: 30, height: 30)  // Adjusted position and width
            cell.contentView.addSubview(repetitionsLabel)

            let weightLabel = UILabel()
            if let weightValue = defaultExercise[indexPath.row]["weight"] as? Int {
                weightLabel.text = String(weightValue)
            } else {
                weightLabel.text = "N/A"
            }
            weightLabel.frame = CGRect(x: 300, y: 10, width: 40, height: 30)  // Adjusted position and width
            cell.contentView.addSubview(weightLabel)

            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Category"
        case 1:
            return "Exercise"
        case 2:
            return "ExerciseCategory"
        case 3:
            return "DefaultExercise"
        default:
            return ""
        }
    }
}
