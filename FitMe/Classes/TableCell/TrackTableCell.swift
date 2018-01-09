//
//  TrackstepTableCell.swift
//  FitMe
//
//  Created by Chandan Makhija on 20/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit

class TrackTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDataToCell(trackIndex:ETrack) {
        switch trackIndex {
        case .Step:
            titleLbl.text = "Track Your Steps"
        case .Water:
            titleLbl.text = "Track Glass of Water"
        }
    }

}
