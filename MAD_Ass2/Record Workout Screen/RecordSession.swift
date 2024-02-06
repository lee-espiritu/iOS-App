//
//  RecordSession.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//  Version: 1.4
//  Description: Class responsible for the session workout tableview, shows the current workout progress

import UIKit

protocol RecordSessionDelegate: AnyObject {
    func quitButtonPressed(in cell: RecordSession)
}

class RecordSession: UITableViewCell {

    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeLeftLabel: UILabel!
    
    weak var delegate: RecordSessionDelegate?
    
    var intervalTimer: Int = 5
    var repetitions: Int = 0
    var sets: Int = 0
    var totalTimeLeft: Int = 0
    var totalTimeLeftOriginal: Int = 0
    
    //Counter for set/reps to go
    var setCounter: Int = 0
    var repCounter: Int = 0
    
    //Main timer properties
    private var timer: Timer?
    private var secondsLeft: Int = 0
    private var isTimerRunning: Bool = false
    
    //Rest timer properties
    private var restTimer: Timer?
    private var restSecondsLeft: Int = 0
    private let restDuration: Int = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timerLabel.text = "00:05"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func restButtonPressed(_ sender: Any) {
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
    
    @objc private func updateRestTimer() {
        restSecondsLeft -= 1

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
    
    private func formattedTimeLeft(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func pauseTimers() {
        isTimerRunning = false
    }
    private func resumeTimers() {
        isTimerRunning = true
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if isTimerRunning {
            print("Pausing timer")
            // Pause the timer
            pauseTimer()
        } else {
            // Start or resume the timer
            print("Resuming timer")
            startOrResumeTimer()
        }
    }

    @IBAction func stopButtonPressed(_ sender: Any) {
        // Stop the timer
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
        secondsLeft = intervalTimer
        totalTimeLeft = totalTimeLeftOriginal
        updateButtonTitle(isPause: false)
        updateTimerLabel()
        updateTimeLeftLabel()
        startButton.setTitle("Start", for: .normal)
    }

    @IBAction func quitButtonPressed(_ sender: Any) {
        delegate?.quitButtonPressed(in: self)
    }
    
    func updateSetsAndRepetitions(setValue: String, repValue: String) {
        sets = Int(setValue) ?? 0
        repetitions = Int(repValue) ?? 0
        print("Sets \(sets), repetitions \(repetitions)")
        print("Total Time Left: \(intervalTimer * repetitions * (sets == 0 ? 1 : sets))")
        totalTimeLeft = intervalTimer * repetitions * (sets == 0 ? 1 : sets)
        totalTimeLeftOriginal = totalTimeLeft
        updateTimeLeftLabel()
    }


    private func startOrResumeTimer() {
        if timer == nil {
            // Start the timer
            isTimerRunning = true
            updateButtonTitle(isPause: true)
            secondsLeft = intervalTimer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            // Resume the timer
            isTimerRunning = true
            updateButtonTitle(isPause: true)
        }
    }

    private func pauseTimer() {
        // Pause the timer
        isTimerRunning = false
        updateButtonTitle(isPause: false)
    }

    private func stopTimer() {
        // Stop the timer
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
        secondsLeft = 0
        updateButtonTitle(isPause: false)
        updateTimerLabel()
        updateTimeLeftLabel()
    }

    @objc private func updateTimer() {
        guard isTimerRunning else {
            return //Do not update the timer if paused
        }
        
        secondsLeft -= 1
        totalTimeLeft -= 1
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
            }
            //reset interval timer
            secondsLeft = intervalTimer
            //startOrResumeTimer()
            updateTimerLabel()
        }
    }

    private func updateTimerLabel() {
        let minutes = secondsLeft / 60
        let seconds = secondsLeft % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateTimeLeftLabel() {
        print("TotalTimeLeft: \(totalTimeLeft)")
        let minutes = totalTimeLeft / 60
        let seconds = totalTimeLeft % 60
        timeLeftLabel.text = "Time Left: \(String(format: "%02d:%02d", minutes, seconds))"
    }

    private func updateButtonTitle(isPause: Bool) {
        if isPause {
            startButton.setTitle("Pause", for: .normal)
        } else if setCounter == sets && repCounter == repetitions{
            startButton.setTitle("Start", for: .normal)
        } else if secondsLeft == 0 {
            startButton.setTitle("Start", for: .normal)
        } else {
            startButton.setTitle("Resume", for: .normal)
        }
    }
}

