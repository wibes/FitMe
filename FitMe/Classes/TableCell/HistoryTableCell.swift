//
//  HistoryTableCell.swift
//  FitMe
//
//  Created by Chandan Makhija on 26/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit

class HistoryTableCell: UITableViewCell {

    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setDataToCell(history:HistoryDetail) {
        self.endDate.text = Utility.string(fromDate: history.endDate!)
        self.startDate.text = Utility.string(fromDate: history.startDate!)
        self.countLbl.text = String(format: "%0.2f", history.count!)
    }
}
