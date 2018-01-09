//
//  MaxGlassTableCell.swift
//  FitMe
//
//  Created by Chandan Makhija on 06/01/18.
//  Copyright © 2018 Chandan Makhija. All rights reserved.
//

import UIKit

class MaxGlassTableCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var maCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setDataToCell(detail:DailyWaterDetail) {
        self.dateLbl.text = Utility.string(fromDate: detail.date!)
        self.maCountLbl.text = String(detail.count!)
    }
}
