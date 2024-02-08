//
//  DBConstants.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//  Student ID: 17459857
//  Campus: Parramatta South
//  Tutor Name: Mark Johnston
//  Class Day: Monday & Wednesday
//  Class Time: 12PM - 2PM
//  Version: 1.0
//
//  Description: Abstract Struct to help prefill database entities with predefined values.

import Foundation

struct DBConstants {
    
    static let categoryLegs = "Legs"
    static let categoryArms = "Arms"
    static let categoryShoulders = "Shoulders"
    static let categoryChest = "Chest"
    static let categoryAbs = "Abs"
    static let categoryNames = [
        categoryLegs,
        categoryShoulders,
        categoryChest,
        categoryArms,
        categoryAbs]
    
    static let exerciseSquats = "Squats" //Legs
    static let exerciseLegPress = "Leg Press" //Legs
    static let exerciseCalfRaise = "Calf Raise" //Legs
    static let exerciseShoulderPress = "Shoulder Press" //Shoulders
    static let exerciseBenchPress = "Bench Press" //Chest
    static let exerciseBicepCurl = "Bicep Curl" //Arms
    static let exerciseCrunches = "Crunches" //Abs
    
    static let exerciseNames = [
        //Legs
        "Barbell Squats",
        "Deadlifts",
        "Leg Press",
        "Lunges",
        "Leg Extensions",
        "Leg Curls",
        "Calf Raises",
        "Step-Ups",
        "Weighted Box Jumps",
        "Sumo Deadlifts",
        
        // Arms
        "Barbell Bicep Curls",
        "Dumbbell Tricep Extensions",
        "Hammer Curls",
        "Tricep Dips",
        "Concentration Curls",
        "Skull Crushers",
        "Preacher Curls",
        "Reverse Grip Tricep Pushdowns",
        "Zottman Curls",
        "Close-Grip Bench Press",
        
        // Shoulders
        "Overhead Press",
        "Lateral Raises",
        "Front Raises",
        "Upright Rows",
        "Shrugs",
        "Face Pulls",
        "Dumbbell Shoulder Press",
        "Arnold Press",
        "Reverse Flyes",
        "Machine Shoulder Press",
        
        // Chest
        "Bench Press",
        "Incline Bench Press",
        "Decline Bench Press",
        "Dumbbell Flyes",
        "Chest Dips",
        "Push-Ups",
        "Chest Press Machine",
        "Pec Deck Machine",
        "Cable Crossover",
        "Machine Flyes",
        
        // Abs
        "Weighted Crunches",
        "Russian Twists with Weight",
        "Hanging Leg Raises",
        "Weighted Planks",
        "Woodchoppers",
        "Medicine Ball Slams",
        "Cable Crunches",
        "Leg Raises",
        "Plank with Shoulder Taps",
        "Bicycle Crunches",
        ]
    
    static let exerciseCategory: [(name: String, category: String)] = [
        // Legs
        ("Barbell Squats", "Legs"),
        ("Deadlifts", "Legs"),
        ("Leg Press", "Legs"),
        ("Lunges", "Legs"),
        ("Leg Extensions", "Legs"),
        ("Leg Curls", "Legs"),
        ("Calf Raises", "Legs"),
        ("Step-Ups", "Legs"),
        ("Weighted Box Jumps", "Legs"),
        ("Sumo Deadlifts", "Legs"),
        
        // Arms
        ("Barbell Bicep Curls", "Arms"),
        ("Dumbbell Tricep Extensions", "Arms"),
        ("Hammer Curls", "Arms"),
        ("Tricep Dips", "Arms"),
        ("Concentration Curls", "Arms"),
        ("Skull Crushers", "Arms"),
        ("Preacher Curls", "Arms"),
        ("Reverse Grip Tricep Pushdowns", "Arms"),
        ("Zottman Curls", "Arms"),
        ("Close-Grip Bench Press", "Arms"),
        
        // Shoulders
        ("Overhead Press", "Shoulders"),
        ("Lateral Raises", "Shoulders"),
        ("Front Raises", "Shoulders"),
        ("Upright Rows", "Shoulders"),
        ("Shrugs", "Shoulders"),
        ("Face Pulls", "Shoulders"),
        ("Dumbbell Shoulder Press", "Shoulders"),
        ("Arnold Press", "Shoulders"),
        ("Reverse Flyes", "Shoulders"),
        ("Machine Shoulder Press", "Shoulders"),
        
        // Chest
        ("Bench Press", "Chest"),
        ("Incline Bench Press", "Chest"),
        ("Decline Bench Press", "Chest"),
        ("Dumbbell Flyes", "Chest"),
        ("Chest Dips", "Chest"),
        ("Push-Ups", "Chest"),
        ("Chest Press Machine", "Chest"),
        ("Pec Deck Machine", "Chest"),
        ("Cable Crossover", "Chest"),
        ("Machine Flyes", "Chest"),
        
        // Abs
        ("Weighted Crunches", "Abs"),
        ("Russian Twists with Weight", "Abs"),
        ("Hanging Leg Raises", "Abs"),
        ("Weighted Planks", "Abs"),
        ("Woodchoppers", "Abs"),
        ("Medicine Ball Slams", "Abs"),
        ("Cable Crunches", "Abs"),
        ("Leg Raises", "Abs"),
        ("Plank with Shoulder Taps", "Abs"),
        ("Bicycle Crunches", "Abs"),
    ]
    
    static let defaultSets = 5
    static let defaultRepetitions = 10
    static let defaultWeight = 20
    
    static let defaultExercise: [(exerciseName: String, categoryName: String, sets: Int, repetitions: Int, weight: Int)] = [
        // Legs
        ("Barbell Squats", "Legs", defaultSets, defaultRepetitions, defaultWeight),
        ("Deadlifts", "Legs", defaultSets, defaultRepetitions, defaultWeight),
        ("Leg Press", "Legs", defaultSets, defaultRepetitions, defaultWeight),
        ("Lunges", "Legs", defaultSets, defaultRepetitions, defaultWeight),
        ("Leg Extensions", "Legs", defaultSets, defaultRepetitions, defaultWeight),
        ("Leg Curls", "Legs", defaultSets, defaultRepetitions, defaultWeight),
        ("Calf Raises", "Legs", defaultSets, defaultRepetitions, defaultWeight),
        ("Step-Ups", "Legs", defaultSets, defaultRepetitions, defaultWeight),
        ("Weighted Box Jumps", "Legs", defaultSets, defaultRepetitions, defaultWeight),
        ("Sumo Deadlifts", "Legs", defaultSets, defaultRepetitions, defaultWeight),
        
        // Arms
        ("Barbell Bicep Curls", "Arms", defaultSets, defaultRepetitions, defaultWeight),
        ("Dumbbell Tricep Extensions", "Arms", defaultSets, defaultRepetitions, defaultWeight),
        ("Hammer Curls", "Arms", defaultSets, defaultRepetitions, defaultWeight),
        ("Tricep Dips", "Arms", defaultSets, defaultRepetitions, defaultWeight),
        ("Concentration Curls", "Arms", defaultSets, defaultRepetitions, defaultWeight),
        ("Skull Crushers", "Arms", defaultSets, defaultRepetitions, defaultWeight),
        ("Preacher Curls", "Arms", defaultSets, defaultRepetitions, defaultWeight),
        ("Reverse Grip Tricep Pushdowns", "Arms", defaultSets, defaultRepetitions, defaultWeight),
        ("Zottman Curls", "Arms", defaultSets, defaultRepetitions, defaultWeight),
        ("Close-Grip Bench Press", "Arms", defaultSets, defaultRepetitions, defaultWeight),
        
        // Shoulders
        ("Overhead Press", "Shoulders", defaultSets, defaultRepetitions, defaultWeight),
        ("Lateral Raises", "Shoulders", defaultSets, defaultRepetitions, defaultWeight),
        ("Front Raises", "Shoulders", defaultSets, defaultRepetitions, defaultWeight),
        ("Upright Rows", "Shoulders", defaultSets, defaultRepetitions, defaultWeight),
        ("Shrugs", "Shoulders", defaultSets, defaultRepetitions, defaultWeight),
        ("Face Pulls", "Shoulders", defaultSets, defaultRepetitions, defaultWeight),
        ("Dumbbell Shoulder Press", "Shoulders", defaultSets, defaultRepetitions, defaultWeight),
        ("Arnold Press", "Shoulders", defaultSets, defaultRepetitions, defaultWeight),
        ("Reverse Flyes", "Shoulders", defaultSets, defaultRepetitions, defaultWeight),
        ("Machine Shoulder Press", "Shoulders", defaultSets, defaultRepetitions, defaultWeight),
        
        // Chest
        ("Bench Press", "Chest", defaultSets, defaultRepetitions, defaultWeight),
        ("Incline Bench Press", "Chest", defaultSets, defaultRepetitions, defaultWeight),
        ("Decline Bench Press", "Chest", defaultSets, defaultRepetitions, defaultWeight),
        ("Dumbbell Flyes", "Chest", defaultSets, defaultRepetitions, defaultWeight),
        ("Chest Dips", "Chest", defaultSets, defaultRepetitions, defaultWeight),
        ("Push-Ups", "Chest", defaultSets, defaultRepetitions, defaultWeight),
        ("Chest Press Machine", "Chest", defaultSets, defaultRepetitions, defaultWeight),
        ("Pec Deck Machine", "Chest", defaultSets, defaultRepetitions, defaultWeight),
        ("Cable Crossover", "Chest", defaultSets, defaultRepetitions, defaultWeight),
        ("Machine Flyes", "Chest", defaultSets, defaultRepetitions, defaultWeight),
        
        // Abs
        ("Weighted Crunches", "Abs", defaultSets, defaultRepetitions, defaultWeight),
        ("Russian Twists with Weight", "Abs", defaultSets, defaultRepetitions, defaultWeight),
        ("Hanging Leg Raises", "Abs", defaultSets, defaultRepetitions, defaultWeight),
        ("Weighted Planks", "Abs", defaultSets, defaultRepetitions, defaultWeight),
        ("Woodchoppers", "Abs", defaultSets, defaultRepetitions, defaultWeight),
        ("Medicine Ball Slams", "Abs", defaultSets, defaultRepetitions, defaultWeight),
        ("Cable Crunches", "Abs", defaultSets, defaultRepetitions, defaultWeight),
        ("Leg Raises", "Abs", defaultSets, defaultRepetitions, defaultWeight),
        ("Plank with Shoulder Taps", "Abs", defaultSets, defaultRepetitions, defaultWeight),
        ("Bicycle Crunches", "Abs", defaultSets, defaultRepetitions, defaultWeight),
    ]

}
