//
//  CoreDataDemoDataSource.swift
//  CoreDataStack
//
//  Created by Ryan Yan on 1/19/18.
//  Copyright © 2018 Jiaqi Yan. All rights reserved.
//

import Foundation

protocol CoreDataDemoDataSource {
    var dataCount: Int { get }

    init(persistenceController: PersistenceController)
    func startGeneratingMockData()
}
