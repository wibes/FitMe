//
//  PersonalDetail.swift
//  FitMe
//
//  Created by Chandan Makhija on 20/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit

let gPersonal = PersonalDetail.sharedInstance

class PersonalDetail: NSObject {
    
    var name:String?
    var weight:String?
    var height:String?
    var targetStep:String?
    
    static let sharedInstance: PersonalDetail = {
        let instance = PersonalDetail()
        return instance
    }()
}
