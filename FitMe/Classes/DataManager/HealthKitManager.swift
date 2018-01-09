//
//  HealthKitManager.swift
//  FitMe
//
//  Created by Chandan Makhija on 22/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit
import HealthKit

let gHeathKitManager = HealthKitManager.sharedInstance

class HealthKitManager: NSObject {
    
    static let sharedInstance = HealthKitManager()
    var healthStore: HKHealthStore = HKHealthStore()
    
     func authorizeHealthKit(completion:@escaping (Bool) -> ()) {
        HealthKitSetupAssistant.authorizeHealthKit {(authorized, error) in
            if !authorized  {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                completion(false)
            } else {
                completion(true)
                print("HealthKit Successfully Authorized.")
            }
        }
    }
    
    func getHKQuantityType(typeOf:ERecord)->HKQuantityType {
        let type:HKQuantityType
        
        switch typeOf {
        case .Step:
            type = HKQuantityType.quantityType(
                forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        case .Calorie:
            type = HKQuantityType.quantityType(
                forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        case .CyclingDistance:
            type = HKQuantityType.quantityType(
                forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!
        }
        
        return type
    }
    
    func getMaxCount(forType:ERecord, quantity:HKQuantity)->Double {
        switch forType {
        case .Calorie:
            return quantity.doubleValue(for: HKUnit.kilocalorie())
        case .Step:
            return quantity.doubleValue(for: HKUnit.count())
        case .CyclingDistance:
            return quantity.doubleValue(for: HKUnit.mile())
        }
    }
    
    func retrieve(historyFor:ERecord ,completion:@escaping ([HistoryDetail]?,Error?)->Void) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 1
        
        var anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        anchorComponents.hour = 0
        
        let anchorDate = calendar.date(from: anchorComponents)
        let cumulativeQuery = HKStatisticsCollectionQuery(quantityType: getHKQuantityType(typeOf: historyFor), quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: dateComponents)
        
        cumulativeQuery.initialResultsHandler = {query, results, error in
            let endDate = Date()
            let startDate = calendar.date(byAdding: .year, value: -1, to: endDate, wrappingComponents: false)
            
            if let myResults = results {
                var historyArr = [HistoryDetail]()
                
                myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
                    if let quantity = statistics.sumQuantity() {
                        historyArr.append(HistoryDetail(startDate: statistics.startDate, endDate: statistics.endDate, count: self.getMaxCount(forType: historyFor, quantity: quantity)))
                    }
                }
                completion(historyArr,nil)
            }
        }
        HKHealthStore().execute(cumulativeQuery)
    }
}
