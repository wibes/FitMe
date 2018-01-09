//
//  HistoryDetail.swift
//  FitMe
//
//  Created by Chandan Makhija on 26/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit

class HistoryDetail: NSObject {
    
    var startDate:Date?
    var endDate:Date?
    var count:Double?
    var type:ERecord?
    
    init(startDate:Date, endDate:Date, count:Double, type:ERecord? = nil) {
        super.init()
        self.startDate = startDate
        self.endDate = endDate
        self.count = count
        self.type = type
    }
}
