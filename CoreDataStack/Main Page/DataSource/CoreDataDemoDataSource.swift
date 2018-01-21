//
//  CoreDataDemoDataSource.swift
//  CoreDataStack
//
//  Created by Ryan Yan on 1/19/18.
//  Copyright © 2018 Jiaqi Yan. All rights reserved.
//

import Foundation

protocol CoreDataDemoDataSource{
    
    var students: [Student]? { get }
    
    weak var delegate: CoreDataDemoDataSourceDelegate? { get set }

    init(persistenceController: PersistenceController)
    func index(of student:Student) -> Int?
    
    func startGeneratingMockData()
    func stopGeneratingMockData()
    func clearGeneratedMockData()
    
}

protocol CoreDataDemoDataSourceDelegate: class {
    
    func didCreated(students: [Student])
    func didSaved(students: [Student])
    
}
