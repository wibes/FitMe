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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let lastSevenDatesArr = Utility.getLastSevenDates()
        initStepGraph(dates: lastSevenDatesArr)
    }
    
    //MARK:- Private methods
    
    private func registerTableCells() {
        tabelView.register(UINib(nibName: "HeaderViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableCell")
    }
    
    private func initVC() {
        registerTableCells()
        
        // Check for HeathKit authorization
        gHeathKitManager.authorizeHealthKit {[unowned self] (authStatus) in
            if authStatus {
                //Set record cells
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
                self.tabelView.reloadSections([ESection.Record.rawValue], with: .automatic)
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
    
    private func initStepGraph(dates:[Date]) {
        cleanArray()

        for date in dates {
            gCoreMotionManager.getPedometerData(fromDate: date, toDate: Utility.getEndDateFor(date: date), completionHandler: {[unowned self] (data) in
                self.stepArr.append(CGFloat(truncating: data.numberOfSteps))
                self.dayStringArr.append(Utility.getDayString(fromDate: date))
                if self.dayStringArr.count == dates.count {
                    DispatchQueue.main.async {
                    self.tabelView.reloadSections([ESection.Graph.rawValue], with: .automatic)
                    }
                }
            })
        }
    }
    
    private func cleanArray() {
        stepArr.removeAll()
        dayStringArr.removeAll()
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
        let kHeaderHeight:CGFloat = 30
        
        return kHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let kHeaderCellIdentifier = "HeaderTableCell"
        let headerCell = tableView.dequeueReusableCell(withIdentifier:kHeaderCellIdentifier) as! HeaderTableViewCell
        
        switch section {
        case ESection.Graph.rawValue:
            let headerView = UIView()
            headerCell.headerLbl.text = "Weekly Steps Record"
            headerView.addSubview(headerCell)
            return headerView
        case ESection.Track.rawValue:
            let headerView = UIView()
            headerCell.headerLbl.text = "Track"
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
        let kTrackCellHeight:CGFloat = 90
        let kRecordCellHeight:CGFloat = 80
        let kGraphCellHeight:CGFloat = 250
        let section:ESection = ESection(rawValue: indexPath.section)!
        
        switch section {
        case .Track:
            return kTrackCellHeight
        case .Record:
            return kRecordCellHeight
        case .Graph:
            return kGraphCellHeight
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
            return recordArr.count == 0 ? 1 : recordArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section:ESection = ESection(rawValue: indexPath.section)!
        let kTrackCellIdentifier = "TrackStepCell"
        let kRecordCellIdentifer = "RecordCell"
        let kGraphCellIdentifer = "GraphCell"
        
        switch section {
        case .Track:
            let cell = tableView.dequeueReusableCell(withIdentifier:kTrackCellIdentifier) as! TrackTableCell
            cell.setDataToCell(trackIndex: ETrack(rawValue: indexPath.row)!)
            return cell
        case .Record:
            guard recordArr.count != 0 else {
                return Utility.createCellWith(message: "No records found")
            }
            let cell = tableView.dequeueReusableCell(withIdentifier:kRecordCellIdentifer) as! RecordTableCell
            cell.setDataToCell(history: recordArr[indexPath.row])
            return cell
        case .Graph:
            let cell = tableView.dequeueReusableCell(withIdentifier:kGraphCellIdentifer) as! GraphTableCell
            cell.setDataToCell(countArr: stepArr, xLabelArr:dayStringArr)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let kDashToStepIdentifier = "DashToTrackStep"
        let kDashToWaterIdentifier = "DashToTrackWater"
        
        if indexPath.section == ESection.Track.rawValue {
            let selectedRow:ETrack = ETrack(rawValue: indexPath.row)!
            
            switch selectedRow {
            case .Step:
                self.performSegue(withIdentifier:kDashToStepIdentifier, sender: nil)
            case .Water:
                self.performSegue(withIdentifier:kDashToWaterIdentifier, sender: nil)
            }
        }
    }
}
