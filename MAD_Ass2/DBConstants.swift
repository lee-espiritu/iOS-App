//
//  DBConstants.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//

import Foundation

struct DBConstants {
    static let categoryLegs = "Legs"
    static let categoryArms = "Arms"
    static let categoryShoulders = "Shoulders"
    static let categoryChest = "Chest"
    static let categoryAbs = "Abs"
    static let categoryNames = [categoryLegs, categoryShoulders, categoryChest, categoryArms, categoryAbs]
    
    static let exerciseSquats = "Squats" //Legs
    static let exerciseLegPress = "Leg Press" //Legs
    static let exerciseCalfRaise = "Calf Raise" //Legs
    static let exerciseShoulderPress = "Shoulder Press" //Shoulders
    static let exerciseBenchPress = "Bench Press" //Chest
    static let exerciseBicepCurl = "Bicep Curl" //Arms
    static let exerciseCrunches = "Crunches" //Abs
    
    static let exerciseNames: [String: [String]] = [
            categoryLegs: ["Squats", "Leg Press", "Calf Raise"],
            categoryShoulders: ["Shoulder Press"],
            categoryChest: ["Bench Press"],
            categoryArms: ["Bicep Curl"],
            categoryAbs: ["Crunches"]
        ]
}
