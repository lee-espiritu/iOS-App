//
//  DisplayLogsScreen.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 6/2/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//
//  Class Description: Handles the Display Logs screen
//

import UIKit
import MessageUI
import UserNotifications


class DisplayLogsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, LogsTableViewCellDelegate, MFMessageComposeViewControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    //Variable to contain all workout records
    var rows: [[String: Any]] = []
    
    //Variable to hold filtered workout records based on day/week/month
    var filteredRows: [[String: Any]] = []
    
    //Variable to hold user selected day
    var selectedDate: String = ""
    
    //State of the screen whether the user is searching by day/week/month
    var isSearchingDay: Bool = false
    
    // Date formatter for date of workout
    let dateFormatter = DateFormatter()
    
    //Default function
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add custom navbar
        view.addSubview(CustomNavBar(title: "Display Logs"))
        
        //Required
        tableView.delegate = self
        tableView.dataSource = self
        
        //Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
        
        //Get all rows
        rows = DBManager.getAllRows(entityName: "WorkoutRecord")
        
        //Set the dateFormatter preferred format
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }
    
    //Added override function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() //Reload tableView when the screen is brought back to view.
    }
    

    //Function triggered when 'Go Back' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //Function triggered when 'Day' button is pressed
    //Inputs: @sender - The object that triggered the function
    @IBAction func dayButtonPressed(_ sender: Any) {
        // Create an instance of DayPickerAlertController
        let dayPickerAlert = DayPickerAlertController(title: "Select a Date", message: nil, preferredStyle: .alert)

        // Add any custom actions if needed
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        dayPickerAlert.addAction(cancelAction)

        // Add the "OK" action
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Store the users selected date
            self.selectedDate = self.dateFormatter.string(from: dayPickerAlert.getSelectedDate())
            
            //Set toggle for day search
            self.isSearchingDay = true
            
            //Reload tableview
            self.tableView.reloadData()
        }
        dayPickerAlert.addAction(okAction)

        // Present the alert from the current view controller
        present(dayPickerAlert, animated: true, completion: nil)
    }
    
    @IBAction func weekButtonPressed(_ sender: Any) {
    }
    
    @IBAction func monthButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func allButtonPressed(_ sender: Any) {
        //Turn off all day/week/month activity
        isSearchingDay = false
        
        //Reload tableView
        tableView.reloadData()
    }
    //Required stub function
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchingDay { //If the user is currently searching for a day
            //Filter rows to selected day
            filteredRows = rows.filter { row in
                // Extract the "date" value from the row dictionary
                if let rowDate = row["date"] as? Date {
                    // Convert the row's date to string with the same format
                    let rowDateString = dateFormatter.string(from: rowDate)
                    // Compare the row's date string with the selected date string
                    return rowDateString == selectedDate
                }
                return false
            }
            return filteredRows.count //Return results of filter
        } else {
            return DBManager.getNumRows(entityName: "WorkoutRecord") //Return count for WorkoutRecord entity
        }
    }
    
    //Required stub function
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearchingDay { //If the user is searching for a specific date
            let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") as! LogsTableViewCell //Initialise reusable cell
            cell.delegate = self //Set cell delegate
            
            //Update UI elements in cell
            cell.dateLabel.text = (filteredRows[indexPath.row]["date"] as? Date).flatMap { dateFormatter.string(from: $0) } ?? "Invalid Date"
            cell.exerciseLabel.text? = filteredRows[indexPath.row]["exerciseName"] as! String
            cell.categoryLabel.text? = filteredRows[indexPath.row]["categoryName"] as! String
            cell.setLabel.text = "\(filteredRows[indexPath.row]["sets"] as! Int32) sets"
            cell.repLabel.text = "\(filteredRows[indexPath.row]["repetitions"] as! Int32) reps"
            cell.weightLabel.text = "\(filteredRows[indexPath.row]["weight"] as! Int32) kg"
            
            //Get the first image in Photos if there is one
            if DBManager.getFirstPhoto() != nil {
                cell.imageSlot.image = DBManager.getFirstPhoto() //Update UIImage of cell
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") as! LogsTableViewCell //Initialise reusable cell
            cell.delegate = self //Set cell delegate
            
            //Update UI elements in cell
            cell.dateLabel.text = (rows[indexPath.row]["date"] as? Date).flatMap { dateFormatter.string(from: $0) } ?? "Invalid Date"
            cell.exerciseLabel.text? = rows[indexPath.row]["exerciseName"] as! String
            cell.categoryLabel.text? = rows[indexPath.row]["categoryName"] as! String
            cell.setLabel.text = "\(rows[indexPath.row]["sets"] as! Int32) sets"
            cell.repLabel.text = "\(rows[indexPath.row]["repetitions"] as! Int32) reps"
            cell.weightLabel.text = "\(rows[indexPath.row]["weight"] as! Int32) kg"
            
            //Get the first image in Photos if there is one
            if DBManager.getFirstPhoto() != nil {
                cell.imageSlot.image = DBManager.getFirstPhoto() //Update UIImage of cell
            }
            
            return cell
        }
    }
    
    //Required stub function
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearchingDay {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") as! LogsTableViewCell
            return cell.bounds.height //Height of cell as seen in storyboard
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") as! LogsTableViewCell
            return cell.bounds.height //Height of cell as seen in storyboard
        }
    }

    //Protocol button to act when 'Take Photo' button is pressed
    func didPressTakePhotoButton(in cell: LogsTableViewCell) {
        print("Take Photo button pressed")
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "TakePhotoScreen") as? TakePhotoScreen {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    //Protocol button to act when 'Send SMS' button is pressed
    func didPressSendSMSButton(in cell: LogsTableViewCell) {
        print("SMS Button Pressed")
        
        //If the device is able to send a text
        if canSendText(){
            var messageVC = MFMessageComposeViewController()
            
            //Compose an appropriate body
            messageVC.body = "I just completed a workout using MAD application";
            
            //Use an array of recipients to send to,
            messageVC.recipients = ["+6144567899"]
            messageVC.messageComposeDelegate = self;
            
            self.present(messageVC, animated: false, completion: nil)
        } else { //Otherwise
            print("SMS messaging is not supported.")
            // Open the Messages app if SMS messaging is not supported
            let sms: String = "sms:&body=I just completed a workout using MAD application"
            let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            if let messagesURL = URL(string: strURL) {
                if UIApplication.shared.canOpenURL(messagesURL) {
                    //UIApplication.shared.open(messagesURL, options: [:], completionHandler: nil)
                    UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
                } else {
                    print("Unable to open Messages app.")
                }
            }
        }
        
        //Send a notification
        let content = UNMutableNotificationContent()
        content.title = "Update"
        content.body = "John has completed another workout, view it here!"

        // Set up the notification trigger (in this example, trigger immediately)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // Create notification request
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)

        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result.rawValue {
        case MessageComposeResult.cancelled.rawValue:
            print("message cancelled")
        default:
            break
        }
    }
    
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
}
