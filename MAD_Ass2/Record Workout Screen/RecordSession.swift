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
    var restTimer: Int = 10
    var repetitions: Int = 0
    var sets: Int = 0
    var totalTimeLeft: Int = 0
    var totalTimeLeftOriginal: Int = 0
    
    var setCounter: Int = 0
    var repCounter: Int = 0
    
    private var timer: Timer?
    private var secondsLeft: Int = 0
    private var isTimerRunning: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timerLabel.text = "00:05"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func restButtonPressed(_ sender: Any) {
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if isTimerRunning {
            print("Pausing timer")
            // Pause the timer
            pauseTimer()
        } else {
            // Start or resume the timer
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
            totalTimeLeft = totalTimeLeftOriginal
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
            stopTimer()
            
            //Increase repetition counter
            repCounter += 1
            //Check if the rep target is reached
            if repCounter == repetitions {
                //Increase set counter
                setCounter += 1
                //Check if the set target is reached
                if setCounter == sets {
                    return
                }
            }
            startOrResumeTimer()
            updateTimerLabel()
        }
    }

    private func updateTimerLabel() {
        let minutes = secondsLeft / 60
        let seconds = secondsLeft % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateTimeLeftLabel() {
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

