//
//  DailyWaterDetail.swift
//  FitMe
//
//  Created by Chandan Makhija on 02/01/18.
//  Copyright © 2018 Chandan Makhija. All rights reserved.
//

import UIKit

class DailyWaterDetail: NSObject {
    
    var date:Date?
    var count:Int?
    
    init(date:Date, count:Int) {
        super.init()
        self.date = date
        self.count = count
    }
}
