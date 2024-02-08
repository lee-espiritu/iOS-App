//
//  DBManager.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//  Version: 1.2
//  Description: Responsible for database actions in the workout program

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
    
    //Prefill ExerciseCategory Entity
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
    
    //Prefill DefaultExercise Entity
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
    //Retrieve the number of rows for a given Entity
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
    
    //Retrieve the number of rows for a given entity using an attribute filter
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
    //Delete all rows for a given entity
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
    
    //======================================UPDATE=======================================================
    static func updateDefaultExercise(exerciseName: String, categoryName: String, sets: Int, repetitions: Int, weight: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DefaultExercise")

        fetchRequest.predicate = NSPredicate(format: "exerciseName == %@ AND categoryName == %@", exerciseName, categoryName)

        do {
            if let existingExercise = try managedContext.fetch(fetchRequest).first {
                existingExercise.setValue(sets, forKey: "sets")
                existingExercise.setValue(repetitions, forKey: "repetitions")
                existingExercise.setValue(weight, forKey: "weight")

                try managedContext.save()
            }
        } catch let error as NSError {
            print("Error updating DefaultExercise: \(error.localizedDescription)")
        }
    }
    //===================================================================================================
    
    
    //===============================SET UP EXERCISE FUNCTION CHAIN=========================================================
    //This function adds input retrieved from the Set Up Exercise screen into their relevant tables
    static func setUpExercise(category: String, exercise: String, reps: Int, sets: Int, weight: Int){
        //Attempt to add category into Category table
        let categoryExists = !addCategory(category: category)
        
        //Attempt to add exercise into Exercise table
        let exerciseExists = !addExercise(exercise: exercise)
        
        //If either exercise or category did not previously exist
        if categoryExists == false || exerciseExists == false {
            //Add category and exercise to ExerciseCategory entity
            addExerciseCategory(category: category, exercise: exercise)
        }
        
        //Add or update row in DefaultExercise
        addUpdateDefaultExercise(category: category, exercise: exercise, reps: reps, sets: sets, weight: weight)
        
        print("Category: \(categoryExists), Exercise: \(exerciseExists)")
    }
    
    
    //This function adds or updates a row in DefaultExercise using categoryName and exerciseName as attributes to match
    static func addUpdateDefaultExercise(category: String, exercise: String, reps: Int, sets: Int, weight: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        // Check if DefaultExercise exists
        let defaultExerciseFetchRequest = NSFetchRequest<DefaultExercise>(entityName: "DefaultExercise")
        defaultExerciseFetchRequest.predicate = NSPredicate(format: "categoryName == %@ AND exerciseName == %@", category, exercise)

        do {
            let defaultExercises = try managedContext.fetch(defaultExerciseFetchRequest)

            if defaultExercises.isEmpty {
                // DefaultExercise does not exist, add it
                let newDefaultExercise = DefaultExercise(context: managedContext)
                newDefaultExercise.categoryName = category
                newDefaultExercise.exerciseName = exercise
                newDefaultExercise.repetitions = Int32(reps)
                newDefaultExercise.sets = Int32(sets)
                newDefaultExercise.weight = Int32(weight)

                // Save changes to the managed context
                do {
                    try managedContext.save()
                    print("Added new record to DefaultExercise")
                } catch {
                    print("Error saving changes: \(error.localizedDescription)")
                }
            } else {
                // DefaultExercise already exists, update the repetitions, sets and weight attributes accordingly.
                let existingDefaultExercise = defaultExercises[0]
                existingDefaultExercise.repetitions = Int32(reps)
                existingDefaultExercise.sets = Int32(sets)
                existingDefaultExercise.weight = Int32(weight)

                // Save changes to the managed context
                do {
                    try managedContext.save()
                    print("Updated record in DefaultExercise")
                } catch {
                    print("Error saving changes: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error fetching DefaultExercise: \(error.localizedDescription)")
        }
    }
    
    //This function attempts to add a category into Category entity. Returns true if there is a successful add, otherwise false
    static func addCategory(category: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return false
            }

            let managedContext = appDelegate.persistentContainer.viewContext

            // Check if Category exists
            let categoryFetchRequest = NSFetchRequest<Category>(entityName: "Category")
            categoryFetchRequest.predicate = NSPredicate(format: "name == %@", category)

            do {
                let categories = try managedContext.fetch(categoryFetchRequest)

                if categories.isEmpty {
                    // Category does not exist, add it
                    let newCategory = Category(context: managedContext)
                    newCategory.name = category

                    // Save changes to the managed context
                    do {
                        try managedContext.save()
                        print("Added Category (\(category))")
                        return true
                    } catch {
                        print("Error saving changes: \(error.localizedDescription)")
                    }
                } else {
                    // Category already exists
                    print("Category (\(category)) already exists")
                    return false
                }
            } catch {
                print("Error fetching Category: \(error.localizedDescription)")
            }
            return false
    }
    
    //This function adds an exercise into the Exercise entity, returns true if there was an addition, otherwise false (already exists)
    static func addExercise(exercise: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        // Check if Exercise exists
        let exerciseFetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
        exerciseFetchRequest.predicate = NSPredicate(format: "name == %@", exercise)

        do {
            let exercises = try managedContext.fetch(exerciseFetchRequest)

            if exercises.isEmpty {
                // Exercise does not exist, add it
                let newExercise = Exercise(context: managedContext)
                newExercise.name = exercise

                // Save changes to the managed context
                do {
                    try managedContext.save()
                    print("Added Exercise (\(exercise))")
                    return true
                } catch {
                    print("Error saving changes: \(error.localizedDescription)")
                }
            } else {
                // Exercise already exists
                print("Exercise (\(exercise)) already exists")
                return false
            }
        } catch {
            print("Error fetching Exercise: \(error.localizedDescription)")
        }

        return false
    }
    
    //This function adds an entry to ExerciseCategory entity given paramters
    static func addExerciseCategory(category: String, exercise: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext

        // Check if ExerciseCategory exists
        let exerciseCategoryFetchRequest = NSFetchRequest<ExerciseCategory>(entityName: "ExerciseCategory")
        exerciseCategoryFetchRequest.predicate = NSPredicate(format: "exerciseName == %@ AND categoryName == %@", exercise, category)

        do {
            let exerciseCategories = try managedContext.fetch(exerciseCategoryFetchRequest)

            if exerciseCategories.isEmpty {
                // ExerciseCategory does not exist, add it
                let newExerciseCategory = ExerciseCategory(context: managedContext)
                newExerciseCategory.exerciseName = exercise
                newExerciseCategory.categoryName = category

                // Save changes to the managed context
                do {
                    try managedContext.save()
                } catch {
                    print("Error saving changes: \(error.localizedDescription)")
                }
            } else {
                // ExerciseCategory already exists
                print("ExerciseCategory already exists for the given exercise and category.")
            }
        } catch {
            print("Error fetching ExerciseCategory: \(error.localizedDescription)")
        }
    }
    //===================================================================================================
    
    //==============================================GETTERS==============================================
    //Retrieve all rows for a given entity
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
    
    //Retrieve all exercise plans from the ExercisePlan category
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
    
    static func getExercisePlan(forDay day: String, index: Int) -> (exerciseName: String, categoryName: String)? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        var exercisePlan: (exerciseName: String, categoryName: String)?

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanWorkout")

        // Add a predicate to filter by the specified day
        fetchRequest.predicate = NSPredicate(format: "day == %@", day)

        do {
            // Execute the fetch request
            let results = try managedContext.fetch(fetchRequest)

            // Check if the index is within bounds
            if index >= 0, index < results.count {
                let result = results[index] as! NSManagedObject

                // Extract exerciseName and categoryName attributes
                if let exerciseName = result.value(forKey: "exerciseName") as? String,
                   let categoryName = result.value(forKey: "categoryName") as? String {
                    // Create a tuple for the exercise
                    exercisePlan = (exerciseName: exerciseName, categoryName: categoryName)
                }
            }
        } catch let error as NSError {
            print("Error fetching exercise plan: \(error.localizedDescription)")
        }

        return exercisePlan
    }

    //Retrieve the default values (Set, repetition, weight) for a given exercise and category
    static func getDefaultValue(forExercise exercise: String, forCategory category: String) -> (sets: String, repetitions: String, weight: String)? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        var defaultValue: (sets: String, repetitions: String, weight: String)?

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DefaultExercise")

        // Add predicates to filter by exerciseName and categoryName
        fetchRequest.predicate = NSPredicate(format: "exerciseName == %@ AND categoryName == %@", exercise, category)

        do {
            // Execute the fetch request
            let results = try managedContext.fetch(fetchRequest)

            // Check if there is a matching record
            if let result = results.first as? NSManagedObject {
                // Extract sets, repetitions, and weight attributes
                if let sets = result.value(forKey: "sets") as? Int,
                   let repetitions = result.value(forKey: "repetitions") as? Int,
                   let weight = result.value(forKey: "weight") as? Int {
                    // Create a tuple for the default values
                    defaultValue = (sets: String(sets), repetitions: String(repetitions), weight: String(weight))
                }
            }
        } catch let error as NSError {
            print("Error fetching default values: \(error.localizedDescription)")
        }

        return defaultValue
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
    
    //Retrieve the exercise name given an index and a category from the ExerciseCategory entity
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
    
    static func getFirstPhoto() -> UIImage? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let firstPhoto = (result as? [NSManagedObject])?.first, let imageData = firstPhoto.value(forKey: "image") as? Data {
                return UIImage(data: imageData)
            }
        } catch let error as NSError {
            print("Could not fetch photo. \(error), \(error.userInfo)")
        }
        
        return nil
    }

    //===================================================================================================
    
    
    
    //=============================================ADD===================================================
    //Add a row to PlanWorkout entity given parameters
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

    
    static func addWorkoutRecord(date: Date, category: String, exercise: String, sets: Int32, repetitions: Int32, weight: Int32) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entityName = "WorkoutRecord"
        let workoutRecordEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let newWorkoutRecord = NSManagedObject(entity: workoutRecordEntity, insertInto: managedContext)

        // Set attributes for WorkoutRecord
        newWorkoutRecord.setValue(date, forKey: "date")
        newWorkoutRecord.setValue(exercise, forKey: "exerciseName")
        newWorkoutRecord.setValue(category, forKey: "categoryName")
        newWorkoutRecord.setValue(sets, forKey: "sets")
        newWorkoutRecord.setValue(repetitions, forKey: "repetitions")
        newWorkoutRecord.setValue(weight, forKey: "weight")

        do {
            try managedContext.save()
            print("Added [\(date), \(category), \(exercise), \(sets), \(repetitions), \(weight)] to WorkoutRecord!")
        } catch {
            print("Error saving Workout Record: \(error.localizedDescription)")
        }
    }
    
    static func addPhoto(imageData: Data) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Photos", in: managedContext)!
        
        let photo = NSManagedObject(entity: entity, insertInto: managedContext)
        photo.setValue(imageData, forKeyPath: "image")
        
        do {
            try managedContext.save()
            print("Photo added successfully.")
        } catch let error as NSError {
            print("Could not save photo. \(error), \(error.userInfo)")
        }
    }
    
    //===================================================================================================
    
    //===================================SET UP DAILY PROGRAM VALIDATION=================================
    //Retrieve the number of unique days selected
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

    //Retrieve the number of exercises for each selected day
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
    

    
    
}
