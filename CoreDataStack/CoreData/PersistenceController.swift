//
//  PersistenceController.swift
//  CoreDataStack
//
//  Created by Ryan Yan on 2018-01-14.
//  Copyright © 2018 Jiaqi Yan. All rights reserved.
//

import Foundation
import CoreData

class PersistenceController:NSObject{
    
    private lazy var applicationDocumentsDirectory: NSURL? = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: "CoreDataStack", withExtension: "momd") else { return nil}
        
        return NSManagedObjectModel(contentsOf: modelURL)
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let managedObjectModel = self.managedObjectModel else { return nil }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = self.applicationDocumentsDirectory?.appendingPathComponent("RyansCoreData.sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            #if DEBUG
                print("CoreData Path: \(String(describing: url))")
            #endif
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data." as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "RyansCoreData", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    private lazy var privateContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    private lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = self.privateContext
        return managedObjectContext
    }()
    
    func save(){
        guard self.privateContext.hasChanges || self.managedObjectContext.hasChanges else { return }

        self.managedObjectContext.performAndWait {
            do {
                try managedObjectContext.save()
                self.privateContext.perform {
                    do {
                        try self.privateContext.save()
                    } catch {
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                        abort()
                    }
                }
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func createChildContext() -> NSManagedObjectContext{
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = self.managedObjectContext
        return childContext
    }
}
