//
//  RecordTableCell.swift
//  FitMe
//
//  Created by Chandan Makhija on 23/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit

enum EUnit:String {
    case KiloCal = "kCal"
    case Miles = "miles"
    case StepCount = "steps"
}

class RecordTableCell: UITableViewCell {

    @IBOutlet weak var activityCount: UILabel!
    @IBOutlet weak var activityDate: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataToCell(history:HistoryDetail) {
        activityDate.text = Utility.string(fromDate: history.startDate!)
        
        switch history.type! {
        case .Calorie:
            activityLabel.text = "Maximum calories burned"
            activityCount.text = String(format: "%0.2f kCal", history.count!)
            activityImageView.image = UIImage(named: "calorie")
            self.tag = ERecord.Calorie.rawValue
        case .CyclingDistance:
            activityLabel.text = "Maximum cycling distance"
            activityCount.text = String(format: "%0.2f miles", history.count!)
            activityImageView.image = UIImage(named: "cycling")
            self.tag = ERecord.CyclingDistance.rawValue
        case .Step:
            activityLabel.text = "Maximum steps taken"
            activityCount.text = String(format: "%0.2f steps", history.count!)
            activityImageView.image = UIImage(named: "footStep")
            self.tag = ERecord.Step.rawValue
        }
    }
}
