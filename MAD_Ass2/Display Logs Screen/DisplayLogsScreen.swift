//
//  DisplayLogsScreen.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 6/2/2024.
//

import UIKit
import MessageUI
import UserNotifications

class DisplayLogsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, LogsTableViewCellDelegate, MFMessageComposeViewControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var rows: [[String: Any]] = []
    
    // Date formatter for date of workout
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add custom navbar
        view.addSubview(CustomNavBar(title: "Display Logs"))
        
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
        for row in rows {
            print(row)
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBManager.getNumRows(entityName: "WorkoutRecord")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") as! LogsTableViewCell
        cell.delegate = self
        
        cell.dateLabel.text = (rows[indexPath.row]["date"] as? Date).flatMap { dateFormatter.string(from: $0) } ?? "Invalid Date"
        cell.exerciseLabel.text? = rows[indexPath.row]["exerciseName"] as! String
        cell.categoryLabel.text? = rows[indexPath.row]["categoryName"] as! String
        cell.setLabel.text = "\(rows[indexPath.row]["sets"] as! Int32) sets"
        cell.repLabel.text = "\(rows[indexPath.row]["repetitions"] as! Int32) reps"
        cell.weightLabel.text = "\(rows[indexPath.row]["weight"] as! Int32) kg"
        
        //Get the first image in Photos if there is one
        if DBManager.getFirstPhoto() != nil {
            cell.imageSlot.image = DBManager.getFirstPhoto()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") as! LogsTableViewCell
        return cell.bounds.height
    }

    func didPressTakePhotoButton(in cell: LogsTableViewCell) {
        print("Take Photo button pressed")
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "TakePhotoScreen") as? TakePhotoScreen {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
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
