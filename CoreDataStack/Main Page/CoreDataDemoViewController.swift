//
//  CoreDataDemoViewController.swift
//  CoreDataStack
//
//  Created by Ryan Yan on 1/18/18.
//  Copyright © 2018 Jiaqi Yan. All rights reserved.
//

import UIKit

class CoreDataDemoViewController: UIViewController, UITableViewDataSource {
    
    var persistenceController: PersistenceController?
    var asyncGeneratedDataSource: CoreDataDemoDataSource?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupTableView()
    }
    
    fileprivate func setupDataSource(){
        guard let persistenceController = persistenceController else { return }
        asyncGeneratedDataSource = AsyncGeneratedDataSource(persistenceController: persistenceController)
        asyncGeneratedDataSource?.startGeneratingMockData()
    }
    
    fileprivate func setupTableView(){
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 15
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.register(UINib.init(nibName: "CoreDataDemoLoggingTableViewCell", bundle: nil), forCellReuseIdentifier: "CoreDataDemoLoggingTableViewCell")
    }
    
    //TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataSource?.dataCount ?? 0
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "CoreDataDemoLoggingTableViewCell") as? CoreDataDemoLoggingTableViewCell else{
            return UITableViewCell()
        }
        cell.logLabel.text = "abcdea\n\n\n\n\nabcdd"
        return cell
    }
    
}
