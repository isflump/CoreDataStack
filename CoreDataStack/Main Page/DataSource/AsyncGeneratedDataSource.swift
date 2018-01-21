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
    
    var timer: Timer?
    
    weak var delegate: CoreDataDemoDataSourceDelegate?
    
    required init(persistenceController: PersistenceController){
        self.context = persistenceController.createChildContext()
        self.persistenceController = persistenceController
        self.persistenceController.delegate = self
    }
    
    func startGeneratingMockData(){
        if timer?.isValid ?? false { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            if let student = self.createAndSaveNewStudent(){
                self.delegate?.didCreated(students: [student])
            }
        }
    }
    
    func stopGeneratingMockData(){
        timer?.invalidate()
    }
    
    func clearGeneratedMockData(){
        deleteAllGeneratedStudentData()
    }
    
    
    
    fileprivate func createAndSaveNewStudent() -> Student?{
        let name = Utils.randomName()
        let gender = Utils.randomGender()
        if let student = self.context.createStudentWith(name: name, gender: gender.rawValue, university: nil){
            self.context.safeSave()
            self.persistenceController.save()
            return student
        }
        return nil
    }
    
    fileprivate func deleteAllGeneratedStudentData(){
        self.context.deleteAllStudents()
        self.persistenceController.save()
    }
    
    // MARK: PersistenceControllerDelegate
    func didFinishInsert(objects: Set<NSManagedObject>){
        if let students = Array(objects) as? [Student]{
            self.delegate?.didSaved(students: students)
            print(students)
        }
    }
    
}
