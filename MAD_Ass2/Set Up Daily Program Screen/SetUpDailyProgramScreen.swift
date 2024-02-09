//
//  SetUpDailyProgram.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 29/1/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Class Description: This class handles main operations of the Set Up Daily Program screen

import UIKit
import EventKit

class SetUpDailyProgramScreen: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, ExercisePlanTableViewCellDelegate {

    //Reference outlet for table view
    @IBOutlet weak var tableView: UITableView!
    
    //Tab Bar reference outlets
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var exerciseTabBarItem: UITabBarItem!
    @IBOutlet weak var dailyProgramTabBarItem: UITabBarItem!
    @IBOutlet weak var recordTabBarItem: UITabBarItem!
    @IBOutlet weak var logTabBarItem: UITabBarItem!
    
    //Calendar event holder
    let workoutEvent = EKEventStore()
    
    //Weekday abbreviations for calendar weekly symbol
    let weekdayAbbreviations: [String: String] = [
        "Sunday": "Sun",
        "Monday": "Mon",
        "Tuesday": "Tue",
        "Wednesday": "Wed",
        "Thursday": "Thu",
        "Friday": "Fri",
        "Saturday": "Sat"
    ]
    
    //Variables to handle selections
    var exercises: [[String: String]] = []
    var selectedDay: Int = 0
    var dayString: String = ""
    var isSelectingCategory: Bool = false
    var isSelectingExercise: Bool = false
    var categorySelected: String = ""
    var exerciseSelected: String = ""
    
    //Reference Outlet for the Save Program Plan button
    @IBOutlet weak var saveProgramPlanButton: UIButton!
    
    //Default function created on class creation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set background
        GradientHelper.addGradient(to: view, colors: [UIColor.cyan, UIColor.systemBlue], startPoint: CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint(x: 0.5, y:1.0))

        //Add the top navbar
        view.addSubview(CustomNavBar(title: "Set Up Daily Program"))
        
        //Required
        tableView.delegate = self
        tableView.dataSource = self
        tabBar.delegate = self

        //Disable the save program plan button
        saveProgramPlanButton.isEnabled = false
        
        //Calendar setup
        switch EKEventStore.authorizationStatus(for: EKEntityType.event) {
            case .authorized:
                print("Authorized")
            case .denied:
                print("Access denied")
            case .notDetermined:
                // If the status is not yet determined the user is prompted to deny or grant access using the requestAccessToEntityType(entityType:completion) method.
                workoutEvent.requestAccess(to: EKEntityType.event, completion: {(granted, error) in
                    if granted {
                        print("Permission granted")
                    } else {
                        print("Access denied")
                    }
                })
            default:
                print("Case Default")
        }
    }

    //Function triggered when 'Go Back' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true) //Return to home screen via root view controller
    }
    
    //Function triggered when 'MON' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func monPressed(_ sender: Any) {
        selectedDay = 1 //Set the selectedDay to 1 indicating Monday
        dayString = "Monday" //Set String version of the day
        exercises = DBManager.getExercisePlan(forDay: dayString) //Retrieve exercises for Monday
        
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    //Function triggered when 'TUE' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func tuePressed(_ sender: Any) {
        selectedDay = 2 //Set the selectedDay to 2 indicating Tuesday
        dayString = "Tuesday" //Set String version of the day
        exercises = DBManager.getExercisePlan(forDay: dayString) //Retrieve exercises for Tuesday
        
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    //Function triggered when 'WED' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func wedPressed(_ sender: Any) {
        selectedDay = 3 //Set the selectedDay to 3 indicating Wednesday
        dayString = "Wednesday" //Set String version of the day
        exercises = DBManager.getExercisePlan(forDay: dayString) //Retrieve exercises for Wednesday
 
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    //Function triggered when 'THU' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func thuPressed(_ sender: Any) {
        selectedDay = 4 //Set the selectedDay to 4 indicating Thursday
        dayString = "Thursday" //Set String version of the day
        exercises = DBManager.getExercisePlan(forDay: dayString) //Retrieve exercises for Thursday

        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    //Function triggered when 'FRI' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func friPressed(_ sender: Any) {
        selectedDay = 5 //Set the selectedDay to 5 indicating Friday
        dayString = "Friday" //Set String version of the day
        exercises = DBManager.getExercisePlan(forDay: dayString) //Retrieve exercises for Friday

        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    //Function triggered when 'SAT' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func satPressed(_ sender: Any) {
        selectedDay = 6 //Set the selectedDay to 6 indicating Saturday
        dayString = "Saturday" //Set String version of the day
        exercises = DBManager.getExercisePlan(forDay: dayString) //Retrieve exercises for Saturday
        
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    //Function triggered when 'SUN' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func sunPressed(_ sender: Any) {
        selectedDay = 7 //Set the selectedDay to 6 indicating Sunday
        dayString = "Sunday" //Set String version of the day
        exercises = DBManager.getExercisePlan(forDay: dayString) //Retrieve exercises for Sunday

        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    //Function triggered when 'Save Program Plan' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func saveProgramPlanButtonPressed(_ sender: Any) {
        //Create a UIAlertController
        let alert = UIAlertController(title: "Program Saved", message: nil, preferredStyle: .alert)

        // Add an "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)

        // Present the alert from the current view controller
        present(alert, animated: true, completion: nil)
        
        //Add workouts to device calendar
        addToDeviceCalendar()
    }
    
    //This function adds planned workouts to the device calendar for the next 3 weeks.
    private func addToDeviceCalendar() {
        //Get all the planned workouts
        let rows = DBManager.getAllRows(entityName: "PlanWorkout")
        print(rows)
        
        // Extract unique days using map, compactMap, and Set initializer
        let uniqueDays = Set(rows.compactMap { $0["day"] as? String })
        
        //Extract unique exercises
        let exercises = Set(rows.compactMap { $0["exerciseName"] as? String })

        //Extract unique categories
        let categories = Set(rows.compactMap { $0["categoryName"] as? String })
        
        //Prepare note description for event
        let exercisesString = "Exercises today: " + exercises.joined(separator: ", ")
        let categoriesString = "Categories worked on: " + categories.joined(separator: ", ")
        
        //For each unique day
        for day in uniqueDays {
            //Get the day for the next 3 occurrences
            let currentDate = Date()
            let nextOccurrences = nextOccurrence(of: weekdayAbbreviations[day]!, startingFrom: currentDate, calendar: Calendar(identifier: .gregorian), occurrences: 3)
            
            // Print or use the next occurrences as needed
            for occurrence in nextOccurrences {
                // Create a DateFormatter for the desired format
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE: dd/MM/yy" // Use "EEEE" for the full day name
                
                //Add workout event
                let startDate = Calendar.current.startOfDay(for: occurrence) // Set this as the occurrence date starting at midnight
                let endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                let event = EKEvent(eventStore: workoutEvent)
                event.calendar = workoutEvent.defaultCalendarForNewEvents
                event.title = "\(day) Workout by MAD"
                event.notes = "\(exercisesString)\n\n\(categoriesString)\n\nEnjoy your workout!"
                event.startDate = startDate
                event.endDate = endDate
                // Save Event in Calendar
                do {
                    try workoutEvent.save(event, span: .thisEvent)
                    print("Stored an event")
                } catch {
                    print("An error occured")
                }
            }
        }
    }
    
    
    //This function grabs the occurrences of a given day. For example if given Monday and the current date is the 4th Feb 2024, then it will grab
    //the next occurences of Monday which would be 5th Feb 2024, 12th, 19th etc.
    func nextOccurrence(of day: String, startingFrom date: Date, calendar: Calendar, occurrences: Int) -> [Date] {
        //Get the weekday index where Monday-Sunday are 1-7 respectively
        let weekdayIndex = calendar.weekdaySymbols.firstIndex(of: day)!
        print("weekdayIndex \(weekdayIndex)")
        
        // Initialize an array to store the next occurrences
        var nextOccurrences: [Date] = []
        
        // Start from the provided date and iterate until we find the desired number of occurrences
        var currentDate = date
        var occurrenceCount = 0
        while occurrenceCount < occurrences {
            // Move to the next day
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
            
            // Check if the weekday of the current date matches the desired weekday index
            if calendar.component(.weekday, from: currentDate) == (weekdayIndex % 7) + 1 {
                // If it matches, add it to the next occurrences array
                nextOccurrences.append(currentDate)
                occurrenceCount += 1 // Increment the occurrence count
            }
        }
        
        // Return the array of next occurrences
        return nextOccurrences
    }

    func insertEvent(_ store: EKEventStore) {
        // The calendarsForEntityType returns all calendars that supports events
        // The event has a start date of the current time and an end date from the current time
        let startDate = Date()
        // 2 hours = 2 hours x 60 minutes x 60 seconds
        let endDate = startDate.addingTimeInterval(2 * 60 * 60)
        // Create event with a title of "New meeting"
        let event = EKEvent(eventStore: store)
        event.calendar = store.defaultCalendarForNewEvents
        event.title = "New Meeting"
        event.startDate = startDate
        event.endDate = endDate
        // Save Event in Calendar
        do {
            try store.save(event, span: .thisEvent)
        } catch {
            print("An error occured")
        }
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If a day has not yet been selected, show nothing in the tableview
        if selectedDay == 0 {
            return 0
        } else if isSelectingCategory { //Check if the user is in the select category screen
            print("Number of categories: \(DBManager.getNumRows(entityName: "Category"))")
            return DBManager.getNumRows(entityName: "Category")
        } else if isSelectingExercise{
            print("Number of exercises in \(categorySelected): \(DBManager.getNumRows(entityName: "ExerciseCategory", categoryName: categorySelected))")
            return DBManager.getNumRows(entityName: "ExerciseCategory", categoryName: categorySelected)
        } else {
            return exercises.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedDay == 0 {
            return UITableViewCell()
        }
        
        
        
        if isSelectingCategory {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
            cell.delegate = self
            cell.category.text? = DBManager.getCategory(index: indexPath.row)
            cell.exercise.text? = ""
            cell.deleteButton.isHidden = true
            return cell
        } else if isSelectingExercise {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
            cell.delegate = self
            cell.category.text? = DBManager.getExercise(index: indexPath.row, category: categorySelected)
            cell.exercise.text? = ""
            cell.deleteButton.isHidden = true
            return cell
        } else {
            if indexPath.row == exercises.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
                cell.deleteButton.isHidden = false
                cell.delegate = self
                if exercises.count < 6 {
                    cell.category.text? = "Select \(6 - exercises.count) more exercise"
                    cell.deleteButton.isHidden = true
                } else {
                    cell.category.text? = "Optional: Add more exercise"
                    cell.deleteButton.isHidden = true
                }
                cell.exercise.text? = ""
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
                cell.deleteButton.isHidden = false
                cell.delegate = self
                cell.category.text? = DBManager.getExercisePlan(forDay: dayString)[indexPath.row]["categoryName"]!
                cell.exercise.text? = DBManager.getExercisePlan(forDay: dayString)[indexPath.row]["exerciseName"]!
                cell.dayString = dayString
                return cell
            }
        }
    }
    
    //Delegate function run when the delete button is pressed on a tableViewCell containing the delete button
    func didPressDeleteButton(for cell: ExercisePlanTableViewCell) {
        //If the indexPath is not nil
        if tableView.indexPath(for: cell) != nil {
            //Update exercises as a row has been deleted
            exercises = DBManager.getExercisePlan(forDay: dayString)
            
            // Reload the table view
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan") as! ExercisePlanTableViewCell
        return cell.bounds.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedDay == 0 {
            return
        }
        
        if isSelectingCategory {
            print("Selected \(DBManager.getCategory(index: indexPath.row))")
            categorySelected = DBManager.getCategory(index: indexPath.row)
            isSelectingCategory = false
            isSelectingExercise = true
            tableView.reloadData()
        } else if isSelectingExercise {
            print("Selected \(DBManager.getExercise(index: indexPath.row, category: categorySelected))")
            exerciseSelected = DBManager.getExercise(index: indexPath.row, category: categorySelected)
            isSelectingExercise = false
            isSelectingCategory = false
            
            //Add selection to DB
            DBManager.addRowPlanWorkout(day: selectedDay, exerciseName: exerciseSelected, categoryName: categorySelected)
            
            //Update exercises as it will be used immediately to display changes
            exercises = DBManager.getExercisePlan(forDay: dayString)
            
            //Update the save program button if validation is met
            if DailyProgramValidationManager.isValidProgram() {
                saveProgramPlanButton.isEnabled = true
            }
            
            print("Reloading Data")
            tableView.reloadData()
        } else {
            //If the user has opted to select more exercises
            if indexPath.row == exercises.count {
                print("Selected 'Select X more exercise' cell")
                isSelectingCategory = true
                tableView.reloadData()
            } else {
                print("Selected regular cell at row \(indexPath.row)")
            }
        }

        // Deselect the row to remove the highlight
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Optional function to set a header title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSelectingCategory {
            return "Select a Category"
        } else if isSelectingExercise{
            return "Select a Exercise"
        } else {
            return "Exercises"
        }
    }

    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Check if the selected item is the homeTabBarItem
        if item == homeTabBarItem {
            navigationController?.popToRootViewController(animated: true)
        } else if item == exerciseTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetUpExerciseScreen") as? SetUpExerciseScreen{
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else if item == dailyProgramTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SetUpDailyProgramScreen") as? SetUpDailyProgramScreen{
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else if item == recordTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "RecordWorkout") as? RecordWorkout{
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } else if item == logTabBarItem {
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "DisplayLogs") as? DisplayLogsScreen{
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }

}
