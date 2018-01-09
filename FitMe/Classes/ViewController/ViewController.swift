//
//  ViewController.swift
//  FitMe
//
//  Created by Chandan Makhija on 19/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit
import HealthKit

enum ESection:Int {
    case Graph = 0
    case Track
    case Record
}

enum ETrack:Int {
    case Step = 0
    case Water
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabelView: UITableView!
    
    var dayStringArr = [String]()
    var stepArr = [CGFloat]()
    var recordArr = [HistoryDetail]()
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
    }
    
    //MARK:- Private methods
    
    private func registerTableCells() {
        tabelView.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableCell")
    }
    
    private func initVC() {
        let last7DatesArr = Utility.getLast7Dates()
        getStepArrayFor(dates: last7DatesArr)
        registerTableCells()
        
        // HeathKit 
        gHeathKitManager.authorizeHealthKit {[unowned self] (authStatus) in
            if authStatus {                
                self.getMaxCount(forType: ERecord.Step)
                self.getMaxCount(forType: ERecord.Calorie)
                self.getMaxCount(forType: ERecord.CyclingDistance)
            }
        }
    }
    
    private func getMaxCount(forType:ERecord) {
        gHeathKitManager.retrieve(historyFor: forType) {[unowned self] (dataArr, error) in
            if let historyArr = dataArr, historyArr.count > 0 {
                let maxHistory = self.findMaxHistoryCount(dataArr: historyArr)
                maxHistory.type = forType
                self.recordArr.append(maxHistory)
                DispatchQueue.main.async {
                    self.tabelView.reloadData()
                }
            }
        }
    }
    
    private func findMaxHistoryCount(dataArr:[HistoryDetail])->HistoryDetail {
        let countArr = dataArr.map { (detail: HistoryDetail) -> Double in
            detail.count!
        }
        let max_count = countArr.max()
        let maxHistory = dataArr.filter{$0.count == max_count}
        
        return maxHistory.last!
    }
    
    private func getStepArrayFor(dates:[Date]) {
        for date in dates {
            gCoreMotionManager.getPedometerData(fromDate: date, toDate: Utility.getEndDateFor(date: date), completionHandler: {[unowned self] (data) in
                self.stepArr.append(CGFloat(truncating: data.numberOfSteps))
                self.dayStringArr.append(Utility.getDayString(fromDate: date))
                if self.dayStringArr.count == dates.count {
                    self.tabelView.reloadRows(at: [IndexPath(row: 0, section: ESection.Graph.rawValue)], with: .automatic)
                }
            })
        }
    }
    
    //MARK:- Navigation Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "DashToHistory" {
            let selectedIndex = tabelView.indexPathForSelectedRow
            let selectedCell = tabelView.cellForRow(at: selectedIndex!) as! RecordTableCell
            let vc = segue.destination as! HistoryViewController
            vc.type = ERecord(rawValue: selectedCell.tag)
        }
    }
    
    //MARK:- UITableView DataSource/Delegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableCell") as! HeaderTableViewCell
        
        switch section {
        case ESection.Graph.rawValue:
            let headerView = UIView()
            headerCell.headerLbl.text = "Weekly Steps Record"
            headerView.addSubview(headerCell)
            return headerView
        case ESection.Record.rawValue:
            let headerView = UIView()
            headerCell.headerLbl.text = "Record"
            headerView.addSubview(headerCell)
            return headerView
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section:ESection = ESection(rawValue: indexPath.section)!
        
        switch section {
        case .Track:
            return 90
        case .Record:
            return 80
        case .Graph:
            return 250
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section:ESection = ESection(rawValue: section)!
        
        switch  section {
        case .Graph:
            return 1
        case .Track:
            return 2
        case .Record:
            return recordArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section:ESection = ESection(rawValue: indexPath.section)!
        
        switch section {
        case .Track:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackStepCell") as! TrackTableCell
            cell.setDataToCell(trackIndex: ETrack(rawValue: indexPath.row)!)
            return cell
        case .Record:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell") as! RecordTableCell
            cell.setDataToCell(history: recordArr[indexPath.row])
            return cell
        case .Graph:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell") as! GraphTableCell
            cell.setDataToCell(countArr: stepArr, xLabelArr:dayStringArr)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == ESection.Track.rawValue {
            let selectedRow:ETrack = ETrack(rawValue: indexPath.row)!
            
            switch selectedRow {
            case .Step:
                self.performSegue(withIdentifier: "DashToTrackStep", sender: nil)
            case.Water:
                self.performSegue(withIdentifier: "DashToTrackWater", sender: nil)
            }
        }
    }
}