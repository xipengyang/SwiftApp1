//
//  CoreDataHelper.swift
//  we sale assistant
//
//  Created by xipeng yang on 15/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper: NSObject {
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xipengyang.TODO_App" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("we_sale_assistant", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("we_sale_assistant.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [NSObject: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func getContext() -> NSManagedObjectContext! {
        return managedObjectContext
    }
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    func rollbackContext () {
        if let moc = self.managedObjectContext {
            if moc.hasChanges {
                moc.rollback()
        }
        }
    }
    
    func getEntities(name : String ) -> [AnyObject] {
        
        let request = NSFetchRequest(entityName: name)
        
        request.returnsObjectsAsFaults = false
        request.predicate = nil
        
        var e: NSError?
        
        var result: [AnyObject]?
        do {
            result = try managedObjectContext!.executeFetchRequest(request)
        } catch let error as NSError {
            e = error
            result = nil
        }
        
        if(result == nil) {
            if let error = e {
                print("fetch error \(error.localizedDescription)")
            }
            return [AnyObject]()
            
        }else {
            return result!
        }
        
    }
    
   func getEntityByPredicate(name: String, predicate: NSPredicate?) -> [AnyObject] {
        
        let request = NSFetchRequest(entityName: name)
        
        request.predicate = predicate
        
        var e: NSError?
        
        var result: [AnyObject]?
        do {
            result = try managedObjectContext!.executeFetchRequest(request)
        } catch let error as NSError {
            e = error
            result = nil
        }
        
        if(result == nil) {
            if let error = e {
                print("fetch error \(error.localizedDescription)")
            }
            return [AnyObject]()
        }else {
            return result!
        }

    }
    
    func getOrNewEntityByPredicate(name: String, predicate: NSPredicate?) -> AnyObject {
        
        let entities = self.getEntityByPredicate(name, predicate: predicate)
        
        
        if entities.count > 0 {
            return entities.last!
        }
        
        return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: self.managedObjectContext!)
        
    }
    
    func newEntity(name: String) -> AnyObject {
        
        return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: self.managedObjectContext!)
        
    }
    
    func deleteObject( obj : NSManagedObject) {
        managedObjectContext?.deleteObject(obj)
    }
    

}
