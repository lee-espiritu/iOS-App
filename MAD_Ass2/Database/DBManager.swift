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
