//
//  RecordSession.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Description: Class responsible for the session workout tableview, shows the current workout progress

import UIKit

// Define a protocol named RecordSessionDelegate, which acts as a delegate for RecordSession objects
protocol RecordSessionDelegate: AnyObject {
    // Method called when the quit button is pressed within a RecordSession object
    func quitButtonPressed(in cell: RecordSession)
}

class RecordSession: UITableViewCell {

    //Cell UI Reference Outlets
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    // Delegate for RecordSessionDelegate protocol
    weak var delegate: RecordSessionDelegate?
    
    var intervalTimer: Int = 5 //Assumed interval timer of 5 seconds
    var repetitions: Int = 0 //Repetition limit to be updated
    var sets: Int = 0 //Set limit to be updated
    
    //Counter for set/reps to go
    var setCounter: Int = 0
    var repCounter: Int = 0
    
    //Main timer properties
    private var timer: Timer?
    private var secondsLeft: Int = 0
    var totalTimeLeft: Int = 0
    var totalTimeLeftOriginal: Int = 0
    private var isTimerRunning: Bool = false
    
    //Rest timer properties
    private var restTimer: Timer?
    private var restSecondsLeft: Int = 0
    private let restDuration: Int = 3
    
    //Default function created on class creation
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set a default text for timerLabel
        timerLabel.text = "00:05"
    }

    //Default function created on class creation
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //Function triggered when 'Rest' button is pressed. Shows a rest timer as an alert.
    //Inputs: @sender - The object that triggered the function
    @IBAction func restButtonPressed(_ sender: Any) {
        showRestAlert() //Show a rest alert
    }
    
    //This function shows a rest timer as an alert while pausing all other existing timers
    private func showRestAlert() {
        // Pause the main timer
        pauseTimers()

        // Initialize rest timer variables
        restSecondsLeft = restDuration

        // Create the rest timer alert
        let restAlert = UIAlertController(title: "Rest Timer", message: "Time Left: \(formattedTimeLeft(restSecondsLeft))", preferredStyle: .alert)

        // Start the rest timer countdown
        restTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRestTimer), userInfo: ["alert": restAlert], repeats: true)

        // Present the alert
        if let viewController = delegate as? UIViewController {
            viewController.present(restAlert, animated: true, completion: nil)
        }
    }
    
    //Updates the rest timer by decrementing the remaining seconds and performing conditional operations
    @objc private func updateRestTimer() {
        restSecondsLeft -= 1 //Decrement rest seconds left by 1

        // Access restAlert and update its message timer
        if let userInfo = restTimer?.userInfo as? [String: Any],
           let restAlert = userInfo["alert"] as? UIAlertController {
            restAlert.message = "Time Left: \(formattedTimeLeft(restSecondsLeft))"
        }
        
        // Check if the rest timer has reached 0
        if restSecondsLeft <= 0 {
            // Stop the rest timer
            restTimer?.invalidate()
            restTimer = nil
            
            // Resume the main timer
            resumeTimers()

            // Dismiss the rest timer alert
            (delegate as? UIViewController)?.dismiss(animated: true, completion: nil)
        }
    }
    

    // This function formats the remaining time  into a string representation of minutes and seconds (MM:SS).
    private func formattedTimeLeft(_ seconds: Int) -> String {
        let minutes = seconds / 60 //Convert seconds to minutes
        let remainingSeconds = seconds % 60 //Get remaining seconds after conversion
        return String(format: "%02d:%02d", minutes, remainingSeconds) //Format and return
    }
    
    //Method to pause timers
    private func pauseTimers() {
        isTimerRunning = false
    }
    
    //Method to resume timers
    private func resumeTimers() {
        isTimerRunning = true
    }
    
    //Function triggered when 'Start' button is pressed.
    //Inputs: @sender - The object that triggered the function
    @IBAction func startButtonPressed(_ sender: Any) {
        if isTimerRunning { //If the timer is running
            //print("Pausing timer")
            // Pause the timer
            pauseTimer()
        } else { //Otherwise
            // Start or resume the timer
            //print("Resuming timer")
            startOrResumeTimer()
        }
    }

    //Function triggered when 'Stop' button is pressed. Ceases and updates all relevant elements
    //Inputs: @sender - The object that triggered the function
    @IBAction func stopButtonPressed(_ sender: Any) {
        // Stop the timer
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
        secondsLeft = intervalTimer
        totalTimeLeft = totalTimeLeftOriginal
        setCounter = 0
        repCounter = 0
        updateButtonTitle(isPause: false)
        updateTimerLabel()
        updateTimeLeftLabel()
        startButton.setTitle("Start", for: .normal)
    }
    

    //Function triggered when 'Quit' button is pressed. Invalidates existing timers
    //Inputs: @sender - The object that triggered the function
    @IBAction func quitButtonPressed(_ sender: Any) {
        //Kill all timers, that is, those using totalTimeLeft, secondsLeft and restSecondsLeft
        // Stop the main timer
        timer?.invalidate()
        timer = nil
        
        // Stop the rest timer
        restTimer?.invalidate()
        restTimer = nil
        
        delegate?.quitButtonPressed(in: self)
    }
    
    
    //This funcion updates the inner sets and repetitions variables to be used to as a benchmark for the counters
    func updateSetsAndRepetitions(setValue: String, repValue: String) {
        sets = Int(setValue) ?? 0
        repetitions = Int(repValue) ?? 0
        //print("Sets \(sets), repetitions \(repetitions)")
        //print("Total Time Left: \(intervalTimer * repetitions * (sets == 0 ? 1 : sets))")
        totalTimeLeft = intervalTimer * repetitions * (sets == 0 ? 1 : sets)
        totalTimeLeftOriginal = totalTimeLeft
        updateTimeLeftLabel()
    }

    //This function begins the timer or resume it if it was paused
    private func startOrResumeTimer() {
        if timer == nil { //If there is no timer
            // Start the timer
            isTimerRunning = true //Toggle
            
            //Update relevant elements for user tracking
            updateButtonTitle(isPause: true)
            secondsLeft = intervalTimer
            totalTimeLeft = totalTimeLeftOriginal
            
            //Set a scheduled timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            // Resume the timer
            isTimerRunning = true //Toggle
            updateButtonTitle(isPause: true)
        }
    }

    //Function to pause the timer
    private func pauseTimer() {
        // Pause the timer
        isTimerRunning = false
        updateButtonTitle(isPause: false)
    }

    //Funciton to stop the timer for modular use
    private func stopTimer() {
        // Stop the timer
        isTimerRunning = false
        
        //invalidate main timer
        timer?.invalidate()
        timer = nil
        
        //Set counters and seconds to 0
        secondsLeft = 0
        setCounter = 0
        repCounter = 0
        
        //Update labels
        updateButtonTitle(isPause: false)
        updateTimerLabel()
        updateTimeLeftLabel()
    }

    //Method that updates the timers
    @objc private func updateTimer() {
        guard isTimerRunning else {
            return //Do not update the timer if paused
        }
        
        //Decrement seconds and total time
        secondsLeft -= 1
        totalTimeLeft -= 1
        
        //Update labels
        updateTimerLabel()
        updateTimeLeftLabel()
        
        if secondsLeft <= 0 {
            //Increase repetition counter
            repCounter += 1
            //Check if the rep target is reached
            if repCounter == repetitions {
                //Increase set counter
                setCounter += 1
                //Reset the rep counter
                repCounter = 0
                //Check if the set target is reached
                if setCounter == sets {
                    //Stop the timer
                    stopTimer()
                    return
                }
                
                //Show rest timer as part of assignment spec
                showRestAlert()
            }
            //reset interval timer
            secondsLeft = intervalTimer
            //startOrResumeTimer()
            updateTimerLabel()
        }
    }

    //Method to update timer label for the user UI
    private func updateTimerLabel() {
        let minutes = secondsLeft / 60
        let seconds = secondsLeft % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    //Method to update time left label for the user UI
    private func updateTimeLeftLabel() {
        print("TotalTimeLeft: \(totalTimeLeft)")
        let minutes = totalTimeLeft / 60
        let seconds = totalTimeLeft % 60
        timeLeftLabel.text = "Time Left: \(String(format: "%02d:%02d", minutes, seconds))"
    }

    //Method that updates the 'Start' button to either Start/Pause/Resume depending on conditions
    private func updateButtonTitle(isPause: Bool) {
        if isPause { //If the timer is paused
            startButton.setTitle("Pause", for: .normal) //Set the title to pause
        } else if setCounter == sets && repCounter == repetitions{ //If sets and repetitions have been reached
            startButton.setTitle("Start", for: .normal) //Set the title to start (implying reset possibility) as the workout is finished
        } else if secondsLeft == 0 { //If the time has run out
            startButton.setTitle("Start", for: .normal) //Set title to start for restart
        } else { //Otherwise
            startButton.setTitle("Resume", for: .normal) //Set title to Resume to indicate timer is currently paused
        }
    }
}

