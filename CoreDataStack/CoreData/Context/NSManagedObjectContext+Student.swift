//
//  NSManagedObjectContext+Student.swift
//  CoreDataStack
//
//  Created by Ryan Yan on 1/19/18.
//  Copyright © 2018 Jiaqi Yan. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext{
    
    func createStudentWith(name: String, gender: String, university: University?) -> Student?{
        guard let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: self) as? Student else { return nil}
        student.name = name
        student.gender = gender
        student.university = university
        
        return student
    }
    
    func getStudents() -> [Student]?{
        let getStudentsRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Student")
        do {
            let students = try self.fetch(getStudentsRequest) as? [Student]
            return students
        } catch {
            fatalError("Failed to fetch students: \(error)")
        }
    }
    
    func deleteAllStudents() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try self.execute(deleteRequest)
            self.safeSave()
        } catch {
            print ("There was an error")
        }
    }
    
    func safeSave() {
        self.performAndWait {
            do{
                try self.save()
            }catch{
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

