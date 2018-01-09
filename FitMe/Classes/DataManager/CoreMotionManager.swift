//
//  CoreMotionManager.swift
//  FitMe
//
//  Created by Chandan Makhija on 29/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit
import CoreMotion

let gCoreMotionManager = CoreMotionManager.sharedInstance

class CoreMotionManager: NSObject {
    
    static let sharedInstance = CoreMotionManager()
    let pedometer = CMPedometer()
    
    //MARK:- CoreMotion Methods
    
    func getPedometerData(fromDate:Date, toDate:Date, completionHandler handler: @escaping (CMPedometerData) -> ()) {
        if(CMPedometer.isStepCountingAvailable()){
            pedometer.queryPedometerData(from: fromDate as Date, to: toDate) {(data, error) -> Void in
                DispatchQueue.main.async {
                    if(error == nil){
                        handler(data!)
                    }
                }
            }
        }
    }
    
    func startPedometerUpdate(from:Date, completionHandler handler:@escaping (CMPedometerData?,Error?) -> ()) {
        pedometer.startUpdates(from: Date(), withHandler:{(pedometerData, error) in
            DispatchQueue.main.async {
                handler(pedometerData,error)
            }
        })
    }
    
    func stopPedometerUpdate() {
        pedometer.stopUpdates()
    }
}
