//
//  CoreDataDemoDataSource.swift
//  CoreDataStack
//
//  Created by Ryan Yan on 1/18/18.
//  Copyright © 2018 Jiaqi Yan. All rights reserved.
//

import Foundation
import CoreData

class AsyncGeneratedDataSource: CoreDataDemoDataSource {
    
    var persistenceController: PersistenceController
    var context: NSManagedObjectContext
    var dataCount: Int {
        get {
            return 0
        }
    }
    
    required init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
        self.context = persistenceController.createChildContext()
        startGeneratingMockData()
    }
    
    func startGeneratingMockData(){
        for _ in 0...10{
            createAndSaveNewStudent()
        }
    }
    
    func managedObjectContextObjectsDidChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> where inserts.count > 0 {
            
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> where updates.count > 0 {
            
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> where deletes.count > 0 {
            
        }
    }
    
    func createAndSaveNewStudent(){
        let name = Utils.randomName()
        let gender = Utils.randomGender()
        if let student = self.context.createStudentWith(name: name, gender: gender.rawValue, university: nil){
            self.context.save(student: student)
            self.persistenceController.save()
        }
    }
    
}
