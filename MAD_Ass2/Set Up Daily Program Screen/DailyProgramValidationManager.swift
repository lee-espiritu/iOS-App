//
//  DailyProgramValidationManager.swift
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
//  Class Description: Class to handle the validation of a Daily Program Plan

import UIKit

class DailyProgramValidationManager: NSObject {

    // Return true if there is at least 6 exercises for each day chosen, and if there is at least 3 days in the plan.
    static func isValidProgram() -> Bool {
        return (numberExercisesValid() && atLeastThreeDays()) //True if there is at least 3 days and 6 exercises
    }

    // Checks if there is at least 6 exercises for each day chosen
    static func numberExercisesValid() -> Bool {
        // Retrieve the data from the "PlanWorkout" entity
        let exerciseCounts = DBManager.getExerciseCountsForDays()

        // Check if each day has at least 6 exercises
        return exerciseCounts.allSatisfy { $0 >= 6 }
    }

    // Checks if there is at least 3 days chosen in the week.
    static func atLeastThreeDays() -> Bool {
        return DBManager.uniqueDaysCount() >= 3
    }
}

