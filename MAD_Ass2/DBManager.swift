//
//  DBManager.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 24/1/2024.
//

import CoreData
import UIKit

class DBManager: NSObject {
    
    static func prefillCategories() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for categoryName in DBConstants.categoryNames {
            let categoryEntity = NSEntityDescription.entity(forEntityName: "Categories", in: managedContext)!
            let category = NSManagedObject(entity: categoryEntity, insertInto: managedContext)
            category.setValue(categoryName, forKeyPath: "name")
        }
        
        do {
            try managedContext.save()
            print("DBManager: Prefilled categories")
        } catch let error as NSError{
            print("Error saving prefill data: \(error.localizedDescription)")
        }
    }
    
    static func prefillExercises(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        var exerciseEntity = NSEntityDescription.entity(forEntityName: "Exercises", in: managedContext)!
        var exercise = NSManagedObject(entity: exerciseEntity, insertInto: managedContext)
        exercise.setValue(DBConstants.exerciseSquats, forKey: "name")
        exercise.setValue(DBConstants.categoryLegs, forKey: "category")
        
        exerciseEntity = NSEntityDescription.entity(forEntityName: "Exercises", in: managedContext)!
        exercise = NSManagedObject(entity: exerciseEntity, insertInto: managedContext)
        exercise.setValue(DBConstants.exerciseLegPress, forKey: "name")
        exercise.setValue(DBConstants.categoryLegs, forKey: "category")
        
        exerciseEntity = NSEntityDescription.entity(forEntityName: "Exercises", in: managedContext)!
        exercise = NSManagedObject(entity: exerciseEntity, insertInto: managedContext)
        exercise.setValue(DBConstants.exerciseCalfRaise, forKey: "name")
        exercise.setValue(DBConstants.categoryLegs, forKey: "category")
        
        exerciseEntity = NSEntityDescription.entity(forEntityName: "Exercises", in: managedContext)!
        exercise = NSManagedObject(entity: exerciseEntity, insertInto: managedContext)
        exercise.setValue(DBConstants.exerciseShoulderPress, forKey: "name")
        exercise.setValue(DBConstants.categoryShoulders, forKey: "category")
        
        exerciseEntity = NSEntityDescription.entity(forEntityName: "Exercises", in: managedContext)!
        exercise = NSManagedObject(entity: exerciseEntity, insertInto: managedContext)
        exercise.setValue(DBConstants.exerciseBenchPress, forKey: "name")
        exercise.setValue(DBConstants.categoryChest, forKey: "category")
        
        exerciseEntity = NSEntityDescription.entity(forEntityName: "Exercises", in: managedContext)!
        exercise = NSManagedObject(entity: exerciseEntity, insertInto: managedContext)
        exercise.setValue(DBConstants.exerciseBicepCurl, forKey: "name")
        exercise.setValue(DBConstants.categoryArms, forKey: "category")
        
        exerciseEntity = NSEntityDescription.entity(forEntityName: "Exercises", in: managedContext)!
        exercise = NSManagedObject(entity: exerciseEntity, insertInto: managedContext)
        exercise.setValue(DBConstants.exerciseCrunches, forKey: "name")
        exercise.setValue(DBConstants.categoryAbs, forKey: "category")
        
        do {
            try managedContext.save()
            print("DBManager: Prefilled Exercises")
        } catch let error as NSError{
            print("Error saving prefill data: \(error.localizedDescription)")
        }
    }
    
    static func retrieveCategoriesCount() -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Categories")
        
        do {
            let categories = try managedContext.fetch(fetchRequest)
            return categories.count
        } catch let error as NSError {
            print("Error retrieving categories count: \(error.localizedDescription)")
            return 0
        }
    }
    
    static func retrieveCategories() -> [String] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Categories")
        
        do {
            let categories = try managedContext.fetch(fetchRequest)
            return categories.compactMap { $0.value(forKeyPath: "name") as? String }
        } catch let error as NSError {
            print("Error retrieving categories: \(error.localizedDescription)")
            return []
        }
    }
    
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
    
    static func retrieveExercisesCount() -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercises")
        
        do {
            let categories = try managedContext.fetch(fetchRequest)
            return categories.count
        } catch let error as NSError {
            print("Error retrieving exercises count: \(error.localizedDescription)")
            return 0
        }
    }
    
    static func exerciseExists(exercise: String, exerciseCategory: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercises")
        
        // Combine conditions for name and category
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND category == %@", exercise, exerciseCategory)
        
        do {
            let matchingExercises = try managedContext.fetch(fetchRequest)
            return !matchingExercises.isEmpty
        } catch let error as NSError {
            print("Error retrieving exercise: \(error.localizedDescription)")
            return false
        }
    }

    
    static func addExercise(exerciseName: String, exerciseCategory: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let exercisesEntity = NSEntityDescription.entity(forEntityName: "Exercises", in: managedContext)!
        
        let newCategory = NSManagedObject(entity: exercisesEntity, insertInto: managedContext)
        newCategory.setValue(exerciseName, forKey: "name")
        newCategory.setValue(exerciseCategory, forKey: "category")
        
        do {
            try managedContext.save()
            print("Exercise '\(exerciseName)' with category '\(exerciseCategory)' added successfully.")
        } catch let error as NSError {
            print("Error adding category: \(error.localizedDescription)")
        }
    }
    
    static func retrieveExercises() -> [(name: String, category: String)] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercises")
        
        do {
            let exercises = try managedContext.fetch(fetchRequest)
            return exercises.compactMap { exercise in
                guard
                    let name = exercise.value(forKeyPath: "name") as? String,
                    let category = exercise.value(forKeyPath: "category") as? String
                else {
                    return nil
                }
                return (name: name, category: category)
            }
        } catch let error as NSError {
            print("Error retrieving exercises: \(error.localizedDescription)")
            return []
        }
    }
    
    static func deleteAllCategories(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Categories")
        do {
            let categories = try managedContext.fetch(fetchRequest)
            for category in categories {
                managedContext.delete(category)
            }
            try managedContext.save()
        } catch {
            print("Error deleting categories: \(error)")
        }
    }
    
    static func deleteAllExercises(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Exercises")
        do {
            let exercises = try managedContext.fetch(fetchRequest)
            for exercise in exercises {
                managedContext.delete(exercise)
            }
            try managedContext.save()
        } catch {
            print("Error deleting categories: \(error)")
        }
    }
    
}
