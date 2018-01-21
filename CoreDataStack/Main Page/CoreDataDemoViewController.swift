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
    
    private var lastRow: Int {
        get{
            return (self.asyncGeneratedDataSource?.students?.count ?? 1) - 1
        }
    }

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var generateDataButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var clearDataButton: UIButton!
    
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
    
    @IBAction func didTapStopButton(_ sender: Any) {
        self.asyncGeneratedDataSource?.stopGeneratingMockData()
    }
    
    @IBAction func didTapClearDataButton(_ sender: Any) {
        self.asyncGeneratedDataSource?.clearGeneratedMockData()
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var didTapClearDataButton: UIButton!
    // MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        for _ in students{
            self.tableView.insertRows(at: [IndexPath(row:self.lastRow, section:0)], with: .bottom)
            self.scrollToBottom()
        }
    }
    
    func didSaved(students: [Student]) {
        
    }
    
    fileprivate func scrollToBottom(){
        self.tableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom , animated: true)
    }
}
