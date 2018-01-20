//
//  CoreDataDemoViewController.swift
//  CoreDataStack
//
//  Created by Ryan Yan on 1/18/18.
//  Copyright © 2018 Jiaqi Yan. All rights reserved.
//

import UIKit

class CoreDataDemoViewController: UIViewController, UITableViewDataSource, CoreDataDemoDataSourceDelegate {

    var persistenceController: PersistenceController?
    var asyncGeneratedDataSource: CoreDataDemoDataSource?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var generateDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupTableView()
    }
    
    fileprivate func setupDataSource(){
        guard let persistenceController = persistenceController else { return }
        asyncGeneratedDataSource = AsyncGeneratedDataSource(persistenceController: persistenceController)
        asyncGeneratedDataSource?.delegate = self
    }
    
    fileprivate func setupTableView(){
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 15
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.register(UINib.init(nibName: "CoreDataDemoLoggingTableViewCell", bundle: nil), forCellReuseIdentifier: "CoreDataDemoLoggingTableViewCell")
    }
    
    @IBAction func didTapGenerateDataButton(_ sender: Any) {
        self.asyncGeneratedDataSource?.startGeneratingMockData()
    }
    // MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataSource?.dataCount ?? 0
        return self.asyncGeneratedDataSource?.students?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CoreDataDemoLoggingTableViewCell") as? CoreDataDemoLoggingTableViewCell else{
            return UITableViewCell()
        }
        let student = self.asyncGeneratedDataSource?.students?[indexPath.item] ?? Student()
        cell.logLabel.text = "Student Name: \(student.name ?? "")   |    Gender: \(student.gender ?? "")"
        return cell
    }
    
    // MARK: CoreDataDemoDataSourceDelegate
    func didCreated(students: [Student]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didSaved(students: [Student]) {
        
    }
}
