//
//  DBManager.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//

import CoreData
import UIKit

class DBManager: NSObject {
    
    //==============================================PREFILL==============================================
    // Prefill Category Entity
    static func prefillCategories() {
        prefillEntity(entityName: "Category", names: DBConstants.categoryNames)
    }

    // Prefill Exercise Entity
    static func prefillExercises() {
        prefillEntity(entityName: "Exercise", names: DBConstants.exerciseNames)
    }
    
    //Used by prefillExercises() and prefillCategories() as a parent function
    static func prefillEntity(entityName: String, names: [String]) {
        // Get the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Loop through names
        for name in names {
            // Create an entity
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
            
            // Create a managed object
            let object = NSManagedObject(entity: entity, insertInto: managedContext)
            
            // Set the name
            object.setValue(name, forKeyPath: "name")
        }
        
        // Save changes to the managed context
        do {
            try managedContext.save()
            print("DBManager: Prefilled \(entityName)")
        } catch let error as NSError {
            // Handle save errors
            print("DBManager: Error saving prefill data for \(entityName): \(error.localizedDescription)")
        }
    }
    
    static func prefillExerciseCategory() {
        // Get the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        // Loop through exerciseCategory array
        for exerciseTuple in DBConstants.exerciseCategory {
            // Create an ExerciseCategory entity
            let exerciseCategoryEntity = NSEntityDescription.entity(forEntityName: "ExerciseCategory", in: managedContext)!

            // Create a managed object for the ExerciseCategory
            let exerciseCategory = NSManagedObject(entity: exerciseCategoryEntity, insertInto: managedContext)

            // Set the exerciseName and categoryName
            exerciseCategory.setValue(exerciseTuple.name, forKeyPath: "exerciseName")
            exerciseCategory.setValue(exerciseTuple.category, forKeyPath: "categoryName")
        }

        // Save changes to the managed context
        do {
            try managedContext.save()
            print("DBManager: Prefilled ExerciseCategory")
        } catch let error as NSError {
            // Handle save errors
            print("DBManager: Error saving prefill data for ExerciseCategory: \(error.localizedDescription)")
        }
    }
    
    static func prefillDefaultExercise() {
        // Get the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        // Loop through defaultExercise array
        for defaultTuple in DBConstants.defaultExercise {
            // Create an DefaultExercise entity
            let defaultExerciseCategoryEntity = NSEntityDescription.entity(forEntityName: "DefaultExercise", in: managedContext)!

            // Create a managed object for the defaultExercise
            let defaultExerciseCategory = NSManagedObject(entity: defaultExerciseCategoryEntity, insertInto: managedContext)

            // Set the exerciseName and categoryName
            defaultExerciseCategory.setValue(defaultTuple.exerciseName, forKeyPath: "exerciseName")
            defaultExerciseCategory.setValue(defaultTuple.categoryName, forKeyPath: "categoryName")
            defaultExerciseCategory.setValue(defaultTuple.sets, forKeyPath: "sets")
            defaultExerciseCategory.setValue(defaultTuple.repetitions, forKeyPath: "repetitions")
            defaultExerciseCategory.setValue(defaultTuple.weight, forKeyPath: "weight")
        }

        // Save changes to the managed context
        do {
            try managedContext.save()
            print("DBManager: Prefilled DefaultExercise")
        } catch let error as NSError {
            // Handle save errors
            print("DBManager: Error saving prefill data for DefaultExercise: \(error.localizedDescription)")
        }
    }
    //===================================================================================================

    //=================================GET ROWS COUNT===============================================
    static func getNumRows(entityName: String) -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let rows = try managedContext.fetch(fetchRequest)
            return rows.count
        } catch let error as NSError {
            print("Error retrieving \(entityName) rows: \(error.localizedDescription)")
            return 0
        }
    }
    
    static func getNumRows(entityName: String, categoryName: String) -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        // Add a predicate to filter by the specified category name
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", categoryName)
        
        do {
            let rows = try managedContext.fetch(fetchRequest)
            return rows.count
        } catch let error as NSError {
            print("Error retrieving \(entityName) rows: \(error.localizedDescription)")
            return 0
        }
    }
    //===================================================================================================
    
    
    //=============================================DELETE===============================================
    static func deleteAllRows(entityName: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            let rows = try managedContext.fetch(fetchRequest)
            for row in rows {
                managedContext.delete(row)
            }
            try managedContext.save()
            print("Deleted all rows for \(entityName)")
        } catch {
            print("Error deleting rows in \(entityName): \(error)")
        }
    }
    //===================================================================================================
    
    
    //==============================================GETTERS==============================================
    static func getAllRows(entityName: String) -> [[String: Any]] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let entities = try managedContext.fetch(fetchRequest)
            return entities.map { entity in
                var attributes = [String: Any]()
                let entityDescription = entity.entity
                for property in entityDescription.properties {
                    let propertyName = property.name
                    attributes[propertyName] = entity.value(forKey: propertyName)
                }
                return attributes
            }
        } catch let error as NSError {
            print("Error retrieving \(entityName) rows: \(error.localizedDescription)")
            return []
        }
    }
    
    //Retrieve all exercises under a given category
    static func getExercises(category: String) -> [String] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        var exercises: [String] = []

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExerciseCategory")

        // Add a predicate to filter by the specified category name
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", category)

        do {
            let results = try managedContext.fetch(fetchRequest)
            for case let result as NSManagedObject in results {
                if let exerciseName = result.value(forKey: "exerciseName") as? String {
                    exercises.append(exerciseName)
                }
            }
        } catch {
            print("Error fetching exercises: \(error)")
        }
        return exercises
    }
    
    static func getExercisePlan(forDay: String) -> [[String: String]] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        var exercisePlan: [[String: String]] = []

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanWorkout")

        // Add a predicate to filter by the specified day
        fetchRequest.predicate = NSPredicate(format: "day == %@", forDay)

        do {
            // Execute the fetch request
            let results = try managedContext.fetch(fetchRequest)

            // Iterate over the results
            for case let result as NSManagedObject in results {
                // Extract exerciseName and categoryName attributes
                if let exerciseName = result.value(forKey: "exerciseName") as? String,
                   let categoryName = result.value(forKey: "categoryName") as? String {
                    // Create a dictionary for each exercise and append it to the array
                    let exerciseDict = ["exerciseName": exerciseName, "categoryName": categoryName]
                    exercisePlan.append(exerciseDict)
                }
            }
        } catch let error as NSError {
            print("Error fetching exercise plan: \(error.localizedDescription)")
        }

        return exercisePlan
    }
    
    //Retrieve the category name given an index
    static func getCategory(index: Int) -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")

        do {
            // Execute the fetch request
            let results = try managedContext.fetch(fetchRequest)

            // Check if the index is within the bounds of the results
            if index >= 0 && index < results.count {
                // Extract the category name from the result at the specified index
                if let category = (results[index] as? NSManagedObject)?.value(forKey: "name") as? String {
                    return category
                }
            }
        } catch let error as NSError {
            print("Error fetching category: \(error.localizedDescription)")
        }

        return ""
    }
    
    static func getExercise(index: Int, category: String) -> String {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExerciseCategory")

        // Add predicates to filter by index and category
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", category)

        do {
            let exercises = try managedContext.fetch(fetchRequest) as! [NSManagedObject]

            // Check if the index is within bounds
            guard index >= 0, index < exercises.count else {
                return "Index out of bounds"
            }

            // Retrieve the exerciseName for the specified index and category
            if let exerciseName = exercises[index].value(forKey: "exerciseName") as? String {
                return exerciseName
            } else {
                return "ExerciseName not found"
            }
        } catch let error as NSError {
            print("Error retrieving ExerciseCategory rows: \(error.localizedDescription)")
            return ""
        }
    }

    //===================================================================================================
    
    
    
    //=============================================ADD===================================================
    static func addRowPlanWorkout(day: Int, exerciseName: String, categoryName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard day >= 1, day <= 7 else {
            // Invalid day
            return
        }
        
        let entityName = "PlanWorkout"
        let planWorkoutEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let newPlanWorkout = NSManagedObject(entity: planWorkoutEntity, insertInto: managedContext)
        
        // Set attributes based on the day
        switch day {
        case 1:
            newPlanWorkout.setValue("Monday", forKey: "day")
        case 2:
            newPlanWorkout.setValue("Tuesday", forKey: "day")
        case 3:
            newPlanWorkout.setValue("Wednesday", forKey: "day")
        case 4:
            newPlanWorkout.setValue("Thursday", forKey: "day")
        case 5:
            newPlanWorkout.setValue("Friday", forKey: "day")
        case 6:
            newPlanWorkout.setValue("Saturday", forKey: "day")
        case 7:
            newPlanWorkout.setValue("Sunday", forKey: "day")
        default:
            // Should not reach here
            return
        }
        
        // Set exerciseName and categoryName
        newPlanWorkout.setValue(exerciseName, forKey: "exerciseName")
        newPlanWorkout.setValue(categoryName, forKey: "categoryName")
        
        // Save the changes
        do {
            try managedContext.save()
            print("Saved new exercise to DB")
        } catch let error as NSError {
            print("Error adding row to PlanWorkout: \(error.localizedDescription)")
        }
    }

    
    //===================================================================================================
    
    //===================================SET UP DAILY PROGRAM VALIDATION=================================
    static func uniqueDaysCount() -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanWorkout")
        
        do {
            let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            // Use a Set to store unique days
            var uniqueDaysSet: Set<String> = Set()

            if let workouts = result {
                for workout in workouts {
                    if let day = workout.value(forKey: "day") as? String {
                        uniqueDaysSet.insert(day)
                    }
                }
            }

            return uniqueDaysSet.count
        } catch let error as NSError {
            print("Error retrieving unique days: \(error.localizedDescription)")
        }

        return 0
    }

    
    static func getExerciseCountsForDays() -> [Int] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanWorkout")
        fetchRequest.propertiesToFetch = ["day"]

        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []

            // Use a dictionary to store the count for each unique day
            var exerciseCountsDictionary: [String: Int] = [:]

            for result in results {
                if let day = result.value(forKey: "day") as? String {
                    exerciseCountsDictionary[day, default: 0] += 1
                }
            }

            // Extract counts from the dictionary in the order of weekdays
            let exerciseCounts = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
                .compactMap { exerciseCountsDictionary[$0] }

            // Print results
            for (day, count) in zip(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], exerciseCounts) {
                print("Day: \(day), Exercise Count: \(count)")
            }

            return exerciseCounts
        } catch let error as NSError {
            print("Error retrieving unique days for exercise counts: \(error.localizedDescription)")
            return []
        }
    }

    //===================================================================================================
    static func categoryExists(category: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Categories")
        fetchRequest.predicate = NSPredicate(format: "name == %@", category)
        
        do {
            let matchingCategories = try managedContext.fetch(fetchRequest)
            return !matchingCategories.isEmpty
        } catch let error as NSError {
            print("Error retrieving category: \(error.localizedDescription)")
            return false
        }
    }
    
    static func addCategory(categoryName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let categoryEntity = NSEntityDescription.entity(forEntityName: "Categories", in: managedContext)!
        
        let newCategory = NSManagedObject(entity: categoryEntity, insertInto: managedContext)
        newCategory.setValue(categoryName, forKey: "name")
        
        do {
            try managedContext.save()
            print("Category '\(categoryName)' added successfully.")
        } catch let error as NSError {
            print("Error adding category: \(error.localizedDescription)")
        }
    }
    
}
