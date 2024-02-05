//
//  DailyProgramValidationManager.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 5/2/2024.
//

import UIKit

class DailyProgramValidationManager: NSObject {

    // Return true if there is at least 6 exercises for each day chosen, and if there is at least 3 days in the plan.
    static func isValidProgram() -> Bool {
        if atLeastThreeDays() {
            print("Days valid")
        } else {
            print("Days not valid")
        }
        
        if numberExercisesValid(){
            print("Num exercises valid")
            print("Exercises: \(DBManager.getExerciseCountsForDays())")
        } else {
            print("Num exercises not valid")
            print("Exercises: \(DBManager.getExerciseCountsForDays())")
        }
        return (numberExercisesValid() && atLeastThreeDays())
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

