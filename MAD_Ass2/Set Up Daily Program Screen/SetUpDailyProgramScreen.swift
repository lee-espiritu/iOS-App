//
//  SetUpDailyProgram.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 29/1/2024.
//

import UIKit
import EventKit

class SetUpDailyProgramScreen: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //Tab Bar reference outlets
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var homeTabBarItem: UITabBarItem!
    @IBOutlet weak var exerciseTabBarItem: UITabBarItem!
    @IBOutlet weak var dailyProgramTabBarItem: UITabBarItem!
    @IBOutlet weak var recordTabBarItem: UITabBarItem!
    @IBOutlet weak var logTabBarItem: UITabBarItem!
    
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
    
    var exercises: [[String: String]] = []
    var selectedDay: Int = 0
    var dayString: String = ""
    var isSelectingCategory: Bool = false
    var isSelectingExercise: Bool = false
    var categorySelected: String = ""
    var exerciseSelected: String = ""
    

    
    @IBOutlet weak var saveProgramPlanButton: UIButton!
    
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
                //Do extra things here if needed after verifying authority
            case .denied:
                print("Access denied")
            case .notDetermined:
                // If the status is not yet determined the user is prompted to deny or grant access using the requestAccessToEntityType(entityType:completion) method.
                workoutEvent.requestAccess(to: EKEntityType.event, completion: {(granted, error) in
                    if granted {
                        print("Permission granted")
                        //Do extra things here if wanted after user gives permission
                    } else {
                        print("Access denied")
                    }
                })
            default:
                print("Case Default")
        }

    }

    @IBAction func goBackPressed(_ sender: Any) {
        //pop the stack, assuming that it will always lead to home screen
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func monPressed(_ sender: Any) {
        selectedDay = 1
        dayString = "Monday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func tuePressed(_ sender: Any) {
        selectedDay = 2
        dayString = "Tuesday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func wedPressed(_ sender: Any) {
        selectedDay = 3
        dayString = "Wednesday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func thuPressed(_ sender: Any) {
        selectedDay = 4
        dayString = "Thursday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func friPressed(_ sender: Any) {
        selectedDay = 5
        dayString = "Friday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func satPressed(_ sender: Any) {
        selectedDay = 6
        dayString = "Saturday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func sunPressed(_ sender: Any) {
        selectedDay = 7
        dayString = "Sunday"
        exercises = DBManager.getExercisePlan(forDay: dayString)
        print("Size of exercises: \(exercises.count)")
        //Animation
        let sectionToReload = 0 // Select the section to reload
        let animation = UITableView.RowAnimation.automatic // Choose the animation type you prefer
        tableView.reloadSections(IndexSet(integer: sectionToReload), with: animation)
    }
    
    @IBAction func saveProgramPlanButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Program Saved", message: nil, preferredStyle: .alert)

        // Cancel button
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //categoryAlert.addAction(cancelAction)

        // Add the "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)

        // Present the alert from the current view controller
        present(alert, animated: true, completion: nil)
        
        //Add workouts to device calendar
        addToDeviceCalendar()
    }
    
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
        
        // Print the unique days
        print(uniqueDays)
        print(exercises)
        print(categories)
        
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
                
                // Format the occurrence date
                let formattedDate = dateFormatter.string(from: occurrence)
                print(formattedDate)
                
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
            cell.category.text? = DBManager.getCategory(index: indexPath.row)
            cell.exercise.text? = ""
            return cell
        } else if isSelectingExercise {
            let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
            cell.category.text? = DBManager.getExercise(index: indexPath.row, category: categorySelected)
            cell.exercise.text? = ""
            return cell
        } else {
            if indexPath.row == exercises.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
                if exercises.count < 6 {
                    cell.category.text? = "Select \(6 - exercises.count) more exercise"
                } else {
                    cell.category.text? = "Optional: Add more exercise"
                }
                cell.exercise.text? = ""
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "exercisePlan", for: indexPath) as! ExercisePlanTableViewCell
                cell.category.text? = DBManager.getExercisePlan(forDay: dayString)[indexPath.row]["categoryName"]!
                cell.exercise.text? = DBManager.getExercisePlan(forDay: dayString)[indexPath.row]["exerciseName"]!
                return cell
            }
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
