//
//  WaterGlassViewController.swift
//  FitMe
//
//  Created by Chandan Makhija on 02/01/18.
//  Copyright © 2018 Chandan Makhija. All rights reserved.
//

import UIKit

enum ESegment:Int {
    case Week = 0
    case Month
    case Year
}

enum EWaterSection:Int {
    case Graph = 0
    case Record
}

class WaterGlassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var manager:SqlLiteManager!
    var detail:[DailyWaterDetail]!
    var maxCountDetail:DailyWaterDetail?
    
    var countArr = [CGFloat]()
    var lblArr = [String]()
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.closeDatabaseConnection()
    }
    
    //MARK:- Private methods
    
    private func initMonthlyGraph() {
        let lastMonthArr = Utility.getLast3Months()
        print(lastMonthArr)
        for month in lastMonthArr {
            let count = manager.getCountSum(forDateType: month)
            guard count != nil else{return}
            countArr.append(CGFloat(count!))
            lblArr.append(String(month.suffix(2)))
        }
    }
    
    private func initYearlyGraph() {
        let lastYearArr = Utility.getYearArr()
        print(lastYearArr)
        for year in lastYearArr {
            let count = manager.getCountSum(forDateType: year)
            guard count != nil else{return}
            countArr.append(CGFloat(count!))
            lblArr.append(year)
        }
    }
    
    private func getMaximumCount() {
        let selectMaxQuery = "SELECT COUNT, DATE FROM (SELECT COUNT, DATE FROM \(kTABLE_NAME) ORDER BY COUNT DESC LIMIT 1);"
        
        if let maxCountArr = manager.getWaterDetailArr(sqlStatement: selectMaxQuery) {
            maxCountDetail = maxCountArr.first
        }
    }
    
    private func initVC() {
        self.navigationItem.title = "Track Water"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        manager = SqlLiteManager()
        manager.initDatabase()
        
        let selectQuery = "SELECT COUNT, DATE FROM WATER_DETAIL;"
        detail =  manager.getWaterDetailArr(sqlStatement: selectQuery)
        
        initWeeklyGraph()
        getMaximumCount()
    }
    
    private func initWeeklyGraph() {
        let seventhDay = Utility.getLastSeventhDate()
        
        var startDate = Utility.string(fromDate: seventhDay)
        startDate = startDate.removeHyphenFromString()
    
        var endDate = Utility.string(fromDate: Date())
        endDate = endDate.removeHyphenFromString()
        
        let selectBtwQuery = "SELECT COUNT, DATE FROM WATER_DETAIL WHERE DATE >= '\(startDate)' AND DATE <= '\(endDate)'"
    
        if let btwDetail = manager.getWaterDetailArr(sqlStatement: selectBtwQuery) {
            guard detail.count != 0 else {
                lblArr.append(Utility.getDayString(fromDate: Date()))
                countArr.append(0)
                
                return
            }
            for  detail in btwDetail {
                lblArr.append(Utility.getDayString(fromDate: detail.date!))
                countArr.append(CGFloat(detail.count!))
            }
        }
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func actionSegmentControl(_ sender: UISegmentedControl) {
        countArr.removeAll()
        lblArr.removeAll()
        
        let selectedSegment:ESegment = ESegment(rawValue: sender.selectedSegmentIndex)!
       
        switch selectedSegment {
        case .Week:
            initWeeklyGraph()
        case .Month:
            initMonthlyGraph()
        case .Year:
            initYearlyGraph()
        }
        tableView.reloadData()
    }
   
    @IBAction func showAlertWithInput() {
        Utility.showAlertWith(title: "Enter Detail", message: "", placeHolderTF: ["Enter date", "Enter glass count"], fromVC: self) {[unowned self] (textfields) in
            guard !textfields[0].text!.isEmpty else {
                return
            }
            let waterDetail = DailyWaterDetail(date: Utility.date(fromString: textfields[1].text!), count: Int(textfields[0].text!)!)
            self.manager.insertWaterDetail(detail: waterDetail)
            self.actionSegmentControl(self.segmentControl)
            self.tableView.reloadData()
        }
    }
    
    //MARK:- TableView Delegate/DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section:EWaterSection = EWaterSection(rawValue: indexPath.section)!
        let graphCellHeight:CGFloat = 250
        let recordCellHeight:CGFloat = 100
        
        switch section {
        case .Graph:
            return graphCellHeight
        case .Record:
            return recordCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section:EWaterSection = EWaterSection(rawValue: section)!
        
        switch  section {
        case .Graph:
            return countArr.count != 0 ? 1 : 0
        case .Record:
            return maxCountDetail != nil ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section:EWaterSection = EWaterSection(rawValue: indexPath.section)!
        let graphCellIdentifier = "GraphCell"
        let recordCellIdentifier = "RecordCell"
        
        switch section {
        case .Graph:
            let cell = tableView.dequeueReusableCell(withIdentifier:
                graphCellIdentifier) as! GraphTableCell
            cell.setDataToCell(countArr: countArr, xLabelArr:lblArr)
            return cell
        case .Record:
            let cell = tableView.dequeueReusableCell(withIdentifier: recordCellIdentifier) as! MaxGlassTableCell
            cell.setDataToCell(detail: maxCountDetail!)
            return cell
        }
    }
}
