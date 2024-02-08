//
//  ViewDatabaseScreen.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Class Description: This class is responsible for handling the contents of the ViewDatabaseScreen

import UIKit

class ViewDatabaseScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Reference outlet for table view
    @IBOutlet weak var tableView: UITableView!
    
    //Variables to store database entity information
    var category: [[String: Any]] = []
    var exercise: [[String: Any]] = []
    var exerciseCategory: [[String: Any]] = []
    var defaultExercise: [[String: Any]] = []
    
    //Default function created on class creation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Required
        tableView.delegate = self
        tableView.dataSource = self
        
        //Apply background gradient
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        //Add the top navbar
        view.addSubview(CustomNavBar(title: "View Database"))
        
        //Reload All data
        reloadData()
    }
    
    //Function that performs reload operations
    func reloadData(){
        tableView.reloadData() //Reload the table view
        
        category = DBManager.getAllRows(entityName: "Category") //Retrieve all the rows for the Category Entity
        exercise = DBManager.getAllRows(entityName: "Exercise") //Retrieve all the rows for the Exercise Entity
        exerciseCategory = DBManager.getAllRows(entityName: "ExerciseCategory") //Retrieve all the rows for the ExerciseCategory Entity
        defaultExercise = DBManager.getAllRows(entityName: "DefaultExercise") //Retrieve all the rows for the DefaultExercise Entity
    }

    //Function triggered when 'Go Back' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true) //Go to home screen
    }
    
    //Function triggered when 'Prefill DB' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func prefillDBPressed(_ sender: Any) {
        //Prefill exercise and category related entities
        DBManager.prefillCategories()
        DBManager.prefillExercises()
        DBManager.prefillExerciseCategory()
        DBManager.prefillDefaultExercise()
        
        //Reload the table view
        reloadData()
    }
    
    //Function triggered when 'Delete DB' button is pressed - Deletes all rows from every entity
    //Inputs: @sender - The object that triggered the function
    @IBAction func deleteDBPressed(_ sender: Any) {
        ///Delete all rows for all entities
        DBManager.deleteAllRows(entityName: "Category")
        DBManager.deleteAllRows(entityName: "Exercise")
        DBManager.deleteAllRows(entityName: "ExerciseCategory")
        DBManager.deleteAllRows(entityName: "DefaultExercise")
        DBManager.deleteAllRows(entityName: "PlanWorkout")
        DBManager.deleteAllRows(entityName: "WorkoutRecord")
        DBManager.deleteAllRows(entityName: "Photos")
        
        //Reload the table view
        reloadData()
    }
    
    //Required function to set the number of rows for each section. Section here indicates the Entity being used
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section { //Depending on the section
        case 0: //If its the Category section
            return DBManager.getNumRows(entityName: "Category") //Return the number of rows in the Category entity
        case 1: //If its the Exercise section
            return DBManager.getNumRows(entityName: "Exercise") //Return the number of rows in the Exercise entity
        case 2: //If its the ExerciseCategory section
            return DBManager.getNumRows(entityName: "ExerciseCategory") //Return the number of rows in the ExerciseCategory entity
        case 3: //If its the DefaultExercise section
            return DBManager.getNumRows(entityName: "DefaultExercise") //Return the number of rows in the DefaultExercise entity
        default: //Should not be reached
            return 0 //Return no rows incase
        }
    }
    
    //Required function to set the cell contents for the given indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { //If its the category section
            //Create a quick UITableViewCell() that has a label to show the name of the category row
            let cell = UITableViewCell()
            cell.textLabel?.text = category[indexPath.row]["name"] as? String
            return cell
        } else if indexPath.section == 1 { //If its the exercise section
            //Create a quick UITableViewCell() that has a label to show the name of the exercise row
            let cell = UITableViewCell()
            cell.textLabel?.text = exercise[indexPath.row]["name"] as? String
            return cell
        } else if indexPath.section == 2 { //If its the ExerciseCategory section
            //Create a quick UITableViewCell() that has two labels to show the name of the exercise and category in a row
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
        } else if indexPath.section == 3 { //If its the DefaultExercise section
            //Create a quick UITableViewCell() that has labels showing category, exercise, sets, repetitions and weight
            let cell = UITableViewCell()

            //Set category label texts and configurations
            let categoryLabel = UILabel()
            categoryLabel.text = defaultExercise[indexPath.row]["categoryName"] as? String
            categoryLabel.frame = CGRect(x: 20, y: 10, width: 60, height: 30)
            categoryLabel.font = UIFont.systemFont(ofSize: 12)
            cell.contentView.addSubview(categoryLabel)

            //Set exercise label texts and configurations
            let exerciseLabel = UILabel()
            exerciseLabel.text = defaultExercise[indexPath.row]["exerciseName"] as? String
            exerciseLabel.frame = CGRect(x: 90, y: 10, width: 120, height: 30)
            exerciseLabel.font = UIFont.systemFont(ofSize: 12)
            cell.contentView.addSubview(exerciseLabel)

            //Set sets label texts and configurations
            let setsLabel = UILabel()
            if let setsValue = defaultExercise[indexPath.row]["sets"] as? Int {
                setsLabel.text = String(setsValue)
            } else {
                setsLabel.text = "N/A"
            }
            setsLabel.frame = CGRect(x: 220, y: 10, width: 30, height: 30)  // Adjusted position and width
            cell.contentView.addSubview(setsLabel)

            //Set repetition label texts and configurations
            let repetitionsLabel = UILabel()
            if let repetitionsValue = defaultExercise[indexPath.row]["repetitions"] as? Int {
                repetitionsLabel.text = String(repetitionsValue)
            } else {
                repetitionsLabel.text = "N/A"
            }
            repetitionsLabel.frame = CGRect(x: 260, y: 10, width: 30, height: 30)  // Adjusted position and width
            cell.contentView.addSubview(repetitionsLabel)

            //Set weight label texts and configurations
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
    
    //Optional function to set the number of sections the table view will have
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 //4 sections for 4 entities.
    }
    
    //Optional function to set a header title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: //Category section
            return "Category"
        case 1: //Exercise section
            return "Exercise"
        case 2: //ExerciseCategory section
            return "ExerciseCategory"
        case 3: //DefaultExercise section
            return "DefaultExercise"
        default:
            return ""
        }
    }
}
