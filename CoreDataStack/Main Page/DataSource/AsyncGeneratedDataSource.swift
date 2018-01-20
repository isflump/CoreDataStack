//
//  CoreDataDemoDataSource.swift
//  CoreDataStack
//
//  Created by Ryan Yan on 1/18/18.
//  Copyright © 2018 Jiaqi Yan. All rights reserved.
//

import Foundation
import CoreData

class AsyncGeneratedDataSource: CoreDataDemoDataSource, PersistenceControllerDelegate{
    
    var persistenceController: PersistenceController
    var context: NSManagedObjectContext
    var students: [Student]? {
        get{
            return self.context.getStudents()
        }
    }
    
    weak var delegate: CoreDataDemoDataSourceDelegate?
    
    required init(persistenceController: PersistenceController){
        self.context = persistenceController.createChildContext()
        self.persistenceController = persistenceController
        self.persistenceController.delegate = self
    }
    
    func startGeneratingMockData(){
        for _ in 0...10{
            if let student = createAndSaveNewStudent(){
                self.delegate?.didCreated(students: [student])
            }
        }
    }
    
    func createAndSaveNewStudent() -> Student?{
        let name = Utils.randomName()
        let gender = Utils.randomGender()
        if let student = self.context.createStudentWith(name: name, gender: gender.rawValue, university: nil){
            self.context.save(student: student)
            self.persistenceController.save()
            return student
        }
        return nil
    }
    
    // MARK: PersistenceControllerDelegate
    func didFinishInsert(objects: Set<NSManagedObject>){
        if let students = Array(objects) as? [Student]{
            self.delegate?.didCreated(students: students)
            print(students)
        }
    }
    
}
