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
    var mocGeneratedDataSource: CoreDataDemoDataSource?
    
    private var lastRow: Int {
        get{
            return (self.mocGeneratedDataSource?.students?.count ?? 1) - 1
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
        mocGeneratedDataSource = MocGeneratedDataSource(persistenceController: persistenceController)
        mocGeneratedDataSource?.delegate = self
    }
    
    fileprivate func setupTableView(){
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 15
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.register(UINib.init(nibName: "CoreDataDemoLoggingTableViewCell", bundle: nil), forCellReuseIdentifier: "CoreDataDemoLoggingTableViewCell")
    }
    
    @IBAction func didTapGenerateDataButton(_ sender: Any) {
        self.mocGeneratedDataSource?.startGeneratingMockData()
    }
    
    @IBAction func didTapStopButton(_ sender: Any) {
        self.mocGeneratedDataSource?.stopGeneratingMockData()
    }
    
    @IBAction func didTapClearDataButton(_ sender: Any) {
        self.mocGeneratedDataSource?.clearGeneratedMockData()
        self.tableView.reloadData()
    }
    
    // MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mocGeneratedDataSource?.students?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CoreDataDemoLoggingTableViewCell") as? CoreDataDemoLoggingTableViewCell else{
            return UITableViewCell()
        }
        let student = self.mocGeneratedDataSource?.students?[indexPath.item] ?? Student()
        cell.logLabel.text = "Generated -> name:\(student.name ?? "") | gender:\(student.gender ?? "")"

        return cell
    }
    
    // MARK: CoreDataDemoDataSourceDelegate
    func didCreated(students: [Student]) {
        DispatchQueue.main.async {
            for _ in students{
                self.tableView.insertRows(at: [IndexPath(row:self.lastRow, section:0)], with: .bottom)
                self.scrollToBottom()
            }
        }
    }
    
    func didSaved(students: [Student]) {
//        DispatchQueue.main.async {
//            for student in students{
//                if let row = self.mocGeneratedDataSource?.students?.index(of: student){
//                    self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
//                }
//            }
//        }
    }
    
    fileprivate func scrollToBottom(){
        self.tableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .bottom , animated: false)
    }
}
