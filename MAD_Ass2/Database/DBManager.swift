//
//  DBManager.swift
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
//  Class Description: Responsible for database actions

import CoreData
import UIKit

class DBManager: NSObject {
    
    //==============================================PREFILL==============================================
    //Function used to populate the Category entity
    static func prefillCategories() {
        prefillEntity(entityName: "Category", names: DBConstants.categoryNames)
    }

    //Function used to populate the Exercise entity
    static func prefillExercises() {
        prefillEntity(entityName: "Exercise", names: DBConstants.exerciseNames)
    }
    
    //Used by prefillExercises() and prefillCategories() for populating Exercise and Category entity.
    //Parameters: entityName - Target entity, names - Array of names to input
    static func prefillEntity(entityName: String, names: [String]) {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return } //Exit the function if unable to retrieve to avoid crashes
        
        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Loop through provided names
        for name in names {
            //Retrieve the entity description for the given entity name
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
            
            //Create a managed object
            let object = NSManagedObject(entity: entity, insertInto: managedContext)
            
            //Set the name into the 'name' attribute of the entity
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
    
    //Function used to populate the ExerciseCategory entity
    static func prefillExerciseCategory() {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        //Loop through exerciseCategory array
        for exerciseTuple in DBConstants.exerciseCategory {
            //Retrieve the entity description for ExerciseCategory
            let exerciseCategoryEntity = NSEntityDescription.entity(forEntityName: "ExerciseCategory", in: managedContext)!

            //Create a managed object
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
    
    //Function used to populate the DefaultExercise entity
    static func prefillDefaultExercise() {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        //Loop through defaultExercise array
        for defaultTuple in DBConstants.defaultExercise {
            //Retrieve the entity description for DefaultExercise
            let defaultExerciseCategoryEntity = NSEntityDescription.entity(forEntityName: "DefaultExercise", in: managedContext)!

            //Create a managed object for the defaultExercise
            let defaultExerciseCategory = NSManagedObject(entity: defaultExerciseCategoryEntity, insertInto: managedContext)

            //Set exercise, category, sets, repetitions and weight
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

    //=================================GET ROWS COUNT====================================================
    //Function used to retrieve the number of rows for a given Entity
    //Parameters: entityName - Target entity
    static func getNumRows(entityName: String) -> Int {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        
        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request to retrieve objects of the provided entityName
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            //Use the fetch request to fetch objects from the managed context core data
            let rows = try managedContext.fetch(fetchRequest)
            
            //Return the fetched rows
            return rows.count
        } catch let error as NSError {
            //Error handling
            print("Error retrieving \(entityName) rows: \(error.localizedDescription)")
            return 0
        }
    }
    
    //Function to retrieve the number of rows for a given entity using an attribute filter
    //Mainly used to retrieve the categoryName attribute from
    static func getNumRows(entityName: String, categoryName: String) -> Int {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        
        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request to retrieve objects of the provided entityName
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        //Add a predicate to filter by the specified categoryName using the categoryName attribute
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", categoryName)
        
        do {
            //Use the fetch request to fetch objects from the managed context core data
            let rows = try managedContext.fetch(fetchRequest)
            
            //Return the fetched rows
            return rows.count
        } catch let error as NSError {
            //Error handling
            print("Error retrieving \(entityName) rows: \(error.localizedDescription)")
            return 0
        }
    }
    //===================================================================================================
    
    
    //=============================================DELETE===============================================
    //Function used to delete all rows for a given entity
    //Parameters: entityName - Target entity
    static func deleteAllRows(entityName: String){
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request to retrieve objects of the provided entityName
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            //Use the fetch request to fetch objects from the managed context core data
            let rows = try managedContext.fetch(fetchRequest)
            
            //For each row
            for row in rows {
                managedContext.delete(row) //Delete the row
            }
            
            //Save changes
            try managedContext.save()
            print("Deleted all rows for \(entityName)")
        } catch {
            //Error handling
            print("Error deleting rows in \(entityName): \(error)")
        }
    }
    //===================================================================================================
    
    //======================================UPDATE=======================================================
    //Function to update the set/repetition/weight number of a row in DefaultExercise entity given matching exerciseName and categoryName
    //Parameters: exerciseName - The exercise name to match.
    //            categoryName - The category name to match
    //            sets - New set value
    //            repetitions - New repetition value
    //            weight - New weight value
    static func updateDefaultExercise(exerciseName: String, categoryName: String, sets: Int, repetitions: Int, weight: Int) {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request to retrieve objects of the DefaultExercise entity
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DefaultExercise")

        //Add a predicate to filter by the given exerciseName and categoryName matching with attributes exerciseName and categoryName
        fetchRequest.predicate = NSPredicate(format: "exerciseName == %@ AND categoryName == %@", exerciseName, categoryName)

        do {
            //If there is an existing exercise
            if let existingExercise = try managedContext.fetch(fetchRequest).first {
                //Update set/repetition/weight
                existingExercise.setValue(sets, forKey: "sets")
                existingExercise.setValue(repetitions, forKey: "repetitions")
                existingExercise.setValue(weight, forKey: "weight")

                //Save changes
                try managedContext.save()
            }
        } catch let error as NSError {
            //Error handling
            print("Error updating DefaultExercise: \(error.localizedDescription)")
        }
    }
    //===================================================================================================
    
    
    //===============================SET UP EXERCISE FUNCTION CHAIN=========================================================
    //This function adds input retrieved from the Set Up Exercise screen into their relevant tables
    //Parameters: category - The category to search/add
    //            exercise - The exercise to search/add
    //            reps - Repetition value
    //            sets - Sets value
    //            weight - Weight value
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
    }
    
    
    //This function adds or updates a row in DefaultExercise using categoryName and exerciseName as attributes to match
    //Parameters: category - The category to search/add
    //            exercise - The exercise to search/add
    //            reps - Repetition value
    //            sets - Sets value
    //            weight - Weight value
    static func addUpdateDefaultExercise(category: String, exercise: String, reps: Int, sets: Int, weight: Int) {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        // Create a fetch request to retrieve objects of the DefaultExercise entity
        let defaultExerciseFetchRequest = NSFetchRequest<DefaultExercise>(entityName: "DefaultExercise")
        
        //Add a predicate to filter by the given category and exercise matching with attributes categoryName and exerciseName
        defaultExerciseFetchRequest.predicate = NSPredicate(format: "categoryName == %@ AND exerciseName == %@", category, exercise)

        do {
            //Fetch filtered rows
            let defaultExercises = try managedContext.fetch(defaultExerciseFetchRequest)

            //If the exercise does not exist
            if defaultExercises.isEmpty {
                //Create and add it
                let newDefaultExercise = DefaultExercise(context: managedContext)
                newDefaultExercise.categoryName = category
                newDefaultExercise.exerciseName = exercise
                newDefaultExercise.repetitions = Int32(reps)
                newDefaultExercise.sets = Int32(sets)
                newDefaultExercise.weight = Int32(weight)
                
                do {
                    // Save changes to the managed context
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

                do {
                    //Save changes to the managed context
                    try managedContext.save()
                    print("Updated record in DefaultExercise")
                } catch {
                    //Error handling
                    print("Error saving changes: \(error.localizedDescription)")
                }
            }
        } catch {
            //Error handling
            print("Error fetching DefaultExercise: \(error.localizedDescription)")
        }
    }
    
    //This function attempts to add a category into Category entity. Returns true if there is a successful add, otherwise false
    //Parameters: category - The name of the category to add
    static func addCategory(category: String) -> Bool {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        // Check if Category exists
        let categoryFetchRequest = NSFetchRequest<Category>(entityName: "Category")
        categoryFetchRequest.predicate = NSPredicate(format: "name == %@", category)

        do {
            //Fetch filtered rows
            let categories = try managedContext.fetch(categoryFetchRequest)

            //If the category does not exist
            if categories.isEmpty {
                //Create and add it
                let newCategory = Category(context: managedContext)
                newCategory.name = category

                do {
                    // Save changes to the managed context
                    try managedContext.save()
                    print("Added Category (\(category))")
                    return true
                } catch {
                    //Error handling
                    print("Error saving changes: \(error.localizedDescription)")
                }
            } else { //Otherwise
                print("Category (\(category)) already exists")
                return false
            }
        } catch {
            //Error handling
            print("Error fetching Category: \(error.localizedDescription)")
        }
        return false
    }
    
    //This function adds an exercise into the Exercise entity, returns true if there was an addition, otherwise false (already exists)
    //Parameters: Exercise - The exercise name to add
    static func addExercise(exercise: String) -> Bool {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        // Check if Exercise exists
        let exerciseFetchRequest = NSFetchRequest<Exercise>(entityName: "Exercise")
        exerciseFetchRequest.predicate = NSPredicate(format: "name == %@", exercise)

        do {
            //Fetch the filtered rows
            let exercises = try managedContext.fetch(exerciseFetchRequest)

            //If the exercise does not exist
            if exercises.isEmpty {
                //Create and add it
                let newExercise = Exercise(context: managedContext)
                newExercise.name = exercise

                do {
                    // Save changes to the managed context
                    try managedContext.save()
                    print("Added Exercise (\(exercise))")
                    return true
                } catch {
                    //Error handling
                    print("Error saving changes: \(error.localizedDescription)")
                }
            } else {
                // Exercise already exists
                print("Exercise (\(exercise)) already exists")
                return false
            }
        } catch {
            //Error handling
            print("Error fetching Exercise: \(error.localizedDescription)")
        }
        
        return false
    }
    
    //This function adds an entry to ExerciseCategory entity given paramters
    //Parameters: category - category name to add
    //            exercise - exercise name to add
    static func addExerciseCategory(category: String, exercise: String) {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext

        // Check if ExerciseCategory exists
        let exerciseCategoryFetchRequest = NSFetchRequest<ExerciseCategory>(entityName: "ExerciseCategory")
        exerciseCategoryFetchRequest.predicate = NSPredicate(format: "exerciseName == %@ AND categoryName == %@", exercise, category)

        do {
            //Fetch filtered rows
            let exerciseCategories = try managedContext.fetch(exerciseCategoryFetchRequest)

            //If the exercise category does not exist
            if exerciseCategories.isEmpty {
                //Create and add it
                let newExerciseCategory = ExerciseCategory(context: managedContext)
                newExerciseCategory.exerciseName = exercise
                newExerciseCategory.categoryName = category

                do {
                    // Save changes to the managed context
                    try managedContext.save()
                } catch {
                    //Error handling
                    print("Error saving changes: \(error.localizedDescription)")
                }
            } else {
                // ExerciseCategory already exists
                print("ExerciseCategory already exists for the given exercise and category.")
            }
        } catch {
            //Error handling
            print("Error fetching ExerciseCategory: \(error.localizedDescription)")
        }
    }
    //===================================================================================================
    
    //==============================================GETTERS==============================================
    //Method to retrieve all rows for a given entity
    //Parameters: entityName - Target entity
    static func getAllRows(entityName: String) -> [[String: Any]] {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve objects of the given entity
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            // Try to fetch all entities of the given entityName from the managed context
            let entities = try managedContext.fetch(fetchRequest)
            
            return entities.map { entity in
                //Create a dictionary for key String
                var attributes = [String: Any]()
                
                //Retrieve entity description
                let entityDescription = entity.entity
                
                //For each property in the entity
                for property in entityDescription.properties {
                    //Get the name of the property
                    let propertyName = property.name
                    
                    //Get the properties value and store it in dictionary
                    attributes[propertyName] = entity.value(forKey: propertyName)
                }
                
                //Return dictionary
                return attributes
            }
        } catch let error as NSError {
            //Error handling
            print("Error retrieving \(entityName) rows: \(error.localizedDescription)")
            return []
        }
    }
    
    //Retrieve all exercises under a given category
    //Parameters: category - The category to look up exercises for
    static func getExercises(category: String) -> [String] {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        //Create a string array to store exercises
        var exercises: [String] = []

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve objects from 'ExerciseCategory' entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExerciseCategory")

        //Add a predicate filter to filter attribute categoryName to match given category
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", category)

        do {
            //Fetch filtered results
            let results = try managedContext.fetch(fetchRequest)
            //For each result
            for case let result as NSManagedObject in results {
                //Grab the exerciseName value and append it to the string array that stores exercises
                if let exerciseName = result.value(forKey: "exerciseName") as? String {
                    exercises.append(exerciseName)
                }
            }
        } catch {
            //Error handling
            print("Error fetching exercises: \(error)")
        }
        
        //Return array of exercises
        return exercises
    }
    
    //Method to retrieve all exercise plans from the ExercisePlan category
    //Parameters: forDay - Day String eg. Monday
    static func getExercisePlan(forDay: String) -> [[String: String]] {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        //Create storage for exercise plans
        var exercisePlan: [[String: String]] = []

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve objects from "PlanWorkout" entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanWorkout")

        // Add a predicate to filter using 'day' to match given forDay
        fetchRequest.predicate = NSPredicate(format: "day == %@", forDay)

        do {
            //Retrieve filtered results
            let results = try managedContext.fetch(fetchRequest)

            //For each result
            for case let result as NSManagedObject in results {
                //Get exerciseName and categoryName attributes
                if let exerciseName = result.value(forKey: "exerciseName") as? String,
                   let categoryName = result.value(forKey: "categoryName") as? String {
                    // Create a dictionary for each exercise and append it to the array
                    let exerciseDict = ["exerciseName": exerciseName, "categoryName": categoryName]
                    exercisePlan.append(exerciseDict)
                }
            }
        } catch let error as NSError {
            //Error handling
            print("Error fetching exercise plan: \(error.localizedDescription)")
        }

        //Return stored exercise plans
        return exercisePlan
    }
    
    //Method to retrieve an exercise plan given a day and an index
    //Parameters: forDay - Target day
    //            index - Target index
    static func getExercisePlan(forDay day: String, index: Int) -> (exerciseName: String, categoryName: String)? {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        //Create variable to hold matched exercise plan
        var exercisePlan: (exerciseName: String, categoryName: String)?

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve objects from "PlanWorkout" entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanWorkout")

        //Filter by attribute day and match it with given day
        fetchRequest.predicate = NSPredicate(format: "day == %@", day)

        do {
            //Get the filtered results
            let results = try managedContext.fetch(fetchRequest)

            // Check if the index is within bounds
            if index >= 0, index < results.count {
                //Retrieve the result object
                let result = results[index] as! NSManagedObject

                //Get exerciseName and categoryName attributes
                if let exerciseName = result.value(forKey: "exerciseName") as? String,
                   let categoryName = result.value(forKey: "categoryName") as? String {
                    //Create a tuple for the exercise
                    exercisePlan = (exerciseName: exerciseName, categoryName: categoryName)
                }
            }
        } catch let error as NSError {
            //Error handling
            print("Error fetching exercise plan: \(error.localizedDescription)")
        }

        //Return stored exercise plan
        return exercisePlan
    }

    //Retrieve the default values (Set, repetition, weight) for a given exercise and category
    //Parameters: forExercise - Target Exercise
    //            forCategory - Target category
    static func getDefaultValue(forExercise exercise: String, forCategory category: String) -> (sets: String, repetitions: String, weight: String)? {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        //Create a variable to hold the default values set/repetitions/weight
        var defaultValue: (sets: String, repetitions: String, weight: String)?

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve objects from 'DefaultExercise' entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DefaultExercise")

        //Add a predicate to filter results using exerciseName and categoryName attributes to match with given exercise and category
        fetchRequest.predicate = NSPredicate(format: "exerciseName == %@ AND categoryName == %@", exercise, category)

        do {
            //Get filtered results
            let results = try managedContext.fetch(fetchRequest)

            //Check if there is a matching record
            if let result = results.first as? NSManagedObject {
                //Get sets, repetitions, and weight attributes
                if let sets = result.value(forKey: "sets") as? Int,
                   let repetitions = result.value(forKey: "repetitions") as? Int,
                   let weight = result.value(forKey: "weight") as? Int {
                    // Create a tuple for the default values
                    defaultValue = (sets: String(sets), repetitions: String(repetitions), weight: String(weight))
                }
            }
        } catch let error as NSError {
            //Error handling
            print("Error fetching default values: \(error.localizedDescription)")
        }

        //Return held default values
        return defaultValue
    }

    
    //Retrieves the category name given an index from the Category entity
    //Parameters: index - Target index
    static func getCategory(index: Int) -> String {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }
        
        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve objects from the 'Category' entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")

        do {
            //Get filtered results
            let results = try managedContext.fetch(fetchRequest)

            // Check if the index is within the bounds of the results
            if index >= 0 && index < results.count {
                //Get the category name from the result at the specified index
                if let category = (results[index] as? NSManagedObject)?.value(forKey: "name") as? String {
                    //Return matched category name
                    return category
                }
            }
        } catch let error as NSError {
            //Error handling
            print("Error fetching category: \(error.localizedDescription)")
        }

        return ""
    }
    
    //Retrieve the exercise name given an index and a category from the ExerciseCategory entity
    //Parameters: index - Target index
    //            category - Target category
    static func getExercise(index: Int, category: String) -> String {
        //Retrieve app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve objects from the ExerciseCategory entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExerciseCategory")

        //Add predicate to filter using categoryName attributes with given category
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", category)

        do {
            //Get filtered results
            let exercises = try managedContext.fetch(fetchRequest) as! [NSManagedObject]

            // Check if the index is within bounds, return otherwise
            guard index >= 0, index < exercises.count else {
                return "Index out of bounds"
            }

            // Retrieve the exerciseName for the specified index and category
            if let exerciseName = exercises[index].value(forKey: "exerciseName") as? String {
                return exerciseName //Return the name of exercise
            } else {
                return "ExerciseName not found" //No match found
            }
        } catch let error as NSError {
            //Error handling
            print("Error retrieving ExerciseCategory rows: \(error.localizedDescription)")
            return ""
        }
    }
    
    //Method to retrieve the first image stored in Photos entity
    static func getFirstPhoto() -> UIImage? {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve objects from the Photos entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        
        //Set the fetch liimt to 1
        fetchRequest.fetchLimit = 1
        
        do {
            //Retrieve filtered results
            let result = try managedContext.fetch(fetchRequest)
            
            //If there is a photo in the database
            if let firstPhoto = (result as? [NSManagedObject])?.first, let imageData = firstPhoto.value(forKey: "image") as? Data {
                return UIImage(data: imageData) //Return it
            }
        } catch let error as NSError {
            //Error handling
            print("Could not fetch photo. \(error), \(error.userInfo)")
        }
        
        return nil
    }

    //===================================================================================================
    
    
    
    //=============================================ADD===================================================
    //Add a row to PlanWorkout entity given parameters
    //Parameters: day - Day of workout
    //            exerciseName - Name of exercise
    //            categoryName - Name of category
    static func addRowPlanWorkout(day: Int, exerciseName: String, categoryName: String) {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Check the day is valid
        guard day >= 1, day <= 7 else {
            // Invalid day
            return
        }
        
        //Store name of entity
        let entityName = "PlanWorkout"
        
        //Retrieve the entity description for PlanWorkout
        let planWorkoutEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        
        //Create a managed object
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
        
        //Save changes
        do {
            try managedContext.save()
            print("Saved new exercise to DB")
        } catch let error as NSError {
            //Error handling
            print("Error adding row to PlanWorkout: \(error.localizedDescription)")
        }
    }

    //Method to add a row into WorkoutRecord entity
    //Parameters: date - Date to put into date attribute
    //            category - Name of category to place into categoryName attribute
    //            exercise - Name of exercise to place into exerciseName attribute
    //            sets - Set value to place into sets attribute
    //            repetitions - Repetition value to place into repetitions attribute
    //            weight - Weight value to place into weight attribute
    static func addWorkoutRecord(date: Date, category: String, exercise: String, sets: Int32, repetitions: Int32, weight: Int32) {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Store entity name
        let entityName = "WorkoutRecord"
        
        //Retrieve the entity description for WorkoutRecord
        let workoutRecordEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        
        //Create a managed object
        let newWorkoutRecord = NSManagedObject(entity: workoutRecordEntity, insertInto: managedContext)

        // Set attributes for WorkoutRecord
        newWorkoutRecord.setValue(date, forKey: "date")
        newWorkoutRecord.setValue(exercise, forKey: "exerciseName")
        newWorkoutRecord.setValue(category, forKey: "categoryName")
        newWorkoutRecord.setValue(sets, forKey: "sets")
        newWorkoutRecord.setValue(repetitions, forKey: "repetitions")
        newWorkoutRecord.setValue(weight, forKey: "weight")

        //Save changes
        do {
            try managedContext.save()
            print("Added [\(date), \(category), \(exercise), \(sets), \(repetitions), \(weight)] to WorkoutRecord!")
        } catch {
            //Error handling
            print("Error saving Workout Record: \(error.localizedDescription)")
        }
    }
    
    //Method to add a photo into the Photos entity
    //Parameter: imageData - The photo to add
    static func addPhoto(imageData: Data) {
        //Retrieve app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Retrieve the entity description for Photos entity
        let entity = NSEntityDescription.entity(forEntityName: "Photos", in: managedContext)!
        
        //Create a managed object
        let photo = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //Set managed object attributes
        photo.setValue(imageData, forKeyPath: "image")
        
        //Save the changes
        do {
            try managedContext.save()
            print("Photo added successfully.")
        } catch let error as NSError {
            //Error handling
            print("Could not save photo. \(error), \(error.userInfo)")
        }
    }
    
    //===================================================================================================
    
    //===================================SET UP DAILY PROGRAM VALIDATION=================================
    //Method to retrieve the number of unique days selected
    static func uniqueDaysCount() -> Int {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }

        //Access the manged context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve objects from the PlanWorkout entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanWorkout")
        
        do {
            //Get fetch results
            let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            
            //Use a Set to store unique days
            var uniqueDaysSet: Set<String> = Set()

            //If there are workouts
            if let workouts = result {
                //For each workout
                for workout in workouts {
                    //Retrieve the day of the workout
                    if let day = workout.value(forKey: "day") as? String {
                        //Insert the day into the set
                        uniqueDaysSet.insert(day)
                    }
                }
            }
            
            //Return the set containing unique days
            return uniqueDaysSet.count
        } catch let error as NSError {
            //Error handling
            print("Error retrieving unique days: \(error.localizedDescription)")
        }
        return 0
    }

    //Method to retrieve the number of exercises for each selected day
    static func getExerciseCountsForDays() -> [Int] {
        //Retrieve the app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }

        //Access the managed context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Create a fetch request to retrieve objects from PlanWorkout entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlanWorkout")
        
        //Set the properties to fetch
        fetchRequest.propertiesToFetch = ["day"]

        do {
            //Retrieve filtered results
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject] ?? []

            // Use a dictionary to store the count for each unique day
            var exerciseCountsDictionary: [String: Int] = [:]

            //For each result
            for result in results {
                //Get the day
                if let day = result.value(forKey: "day") as? String {
                    //Increment count for that day
                    exerciseCountsDictionary[day, default: 0] += 1
                }
            }

            // Extract counts from the dictionary in the order of weekdays
            let exerciseCounts = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
                .compactMap { exerciseCountsDictionary[$0] }

            // Print results
            //for (day, count) in zip(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], exerciseCounts) {
            //    print("Day: \(day), Exercise Count: \(count)")
            //}

            return exerciseCounts
        } catch let error as NSError {
            //Error handling
            print("Error retrieving unique days for exercise counts: \(error.localizedDescription)")
            return []
        }
    }
    //===================================================================================================
}
