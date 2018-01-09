//
//  HistoryViewController.swift
//  FitMe
//
//  Created by Chandan Makhija on 26/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    var type:ERecord?
    var historyArr:[HistoryDetail]?
    
    //MARK: LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
    }
    
    //MARK: Private Methods
    
    private func initVC() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if type == ERecord.Calorie {
            getHistory(dataFor: ERecord.Calorie)
            bannerImageView.image = UIImage(named: "calorie_banner")
        } else if type == ERecord.Step {
            getHistory(dataFor: ERecord.Step)
            bannerImageView.image = UIImage(named: "running_banner")
        } else {
            getHistory(dataFor: ERecord.CyclingDistance)
            bannerImageView.image = UIImage(named: "cycling_banner")
        }
    }
    
    private func getHistory(dataFor:ERecord) {
        gHeathKitManager.retrieve(historyFor: dataFor) { [unowned self](dataArr, error) in
            if error == nil {
                self.historyArr = dataArr
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    //MARK: TableView Delegates/DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArr != nil ? (historyArr?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableCell") as! HistoryTableCell
        cell.setDataToCell(history: historyArr![indexPath.row])
        return cell
    }
}
