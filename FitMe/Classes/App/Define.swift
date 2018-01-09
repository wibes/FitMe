//
//  Define.swift
//  FitMe
//
//  Created by Chandan Makhija on 06/01/18.
//  Copyright © 2018 Chandan Makhija. All rights reserved.
//

import UIKit

//MARK:- Constant

let kDATE_FORMAT = "yyyy-MM-dd"
let kPERSONAL_ENTITY = "Personal"
let kWATER_DATABASE = "water_detail.db"
let kTABLE_NAME = "WATER_DETAIL"

//MARK:- Enumeration

enum ERecord:Int {
    case Step = 0
    case Calorie
    case CyclingDistance
}

//MARK:- Extension

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func removeHyphenFromString()->String {
        return self.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
    }
    
    mutating func insertHyphen()->String {
        self.insert("-", at:self.index(self.startIndex, offsetBy: 4))
        self.insert("-", at:self.index(self.endIndex, offsetBy: -2))
        
        return self
    }
}
