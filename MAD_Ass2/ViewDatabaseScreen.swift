//
//  ViewDatabaseScreen.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//  Version: 1.0
//  Description: This class is responsible for handling the contents of the ViewDatabaseScreen
//

import UIKit

class ViewDatabaseScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //Connect Table Views to display database tables.
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Required
        categoriesTableView.delegate = self
        exercisesTableView.delegate = self
        categoriesTableView.dataSource = self
        exercisesTableView.dataSource = self

        //Apply background gradient
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))
        
        
        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        
        reloadData()
    }
    
    func reloadData(){
        categoriesTableView.reloadData()
        exercisesTableView.reloadData()
    }

    @IBAction func deleteDBButtonPressed(_ sender: Any) {
        DBManager.deleteAllCategories()
        DBManager.deleteAllExercises()
        reloadData()
    }
    
    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func prefillButtonPressed(_ sender: Any) {
        DBManager.prefillCategories()
        DBManager.prefillExercises()
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoriesTableView {
            return DBManager.retrieveCategoriesCount()
        } else if tableView == exercisesTableView {
            return DBManager.retrieveExercisesCount()
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == categoriesTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
            let categories = DBManager.retrieveCategories()
            cell.textLabel?.text = categories[indexPath.row]
            
            //Alternate colours between records
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0) : UIColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
            
            return cell
        } else if tableView == exercisesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExercisesTableViewCell
            let exercises = DBManager.retrieveExercises()
            cell.exerciseName?.text = exercises[indexPath.row].name
            cell.exerciseCategory?.text = exercises[indexPath.row].category
            
            //Alternate colours between records
            cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0) : UIColor(red: 1.0, green: 1.0, blue: 0.9, alpha: 1.0)
            
            return cell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        //Test
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == categoriesTableView {
            return "Categories"
        } else if tableView == exercisesTableView {
            return "Exercises"
        }
        return nil
    }
    
}
