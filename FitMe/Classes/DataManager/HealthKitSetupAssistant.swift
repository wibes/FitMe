//
//  HealthKitSetupAssistant.swift
//  FitMe
//
//  Created by Chandan Makhija on 02/01/18.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import HealthKit

class HealthKitSetupAssistant {
  
  private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
     guard HKHealthStore.isHealthDataAvailable() else {
     completion(false, HealthkitSetupError.notAvailableOnDevice)
        
      return
    }
    
    guard
            let stepCount =                                      HKObjectType.quantityType(forIdentifier: .stepCount),
            let cyclingDistance = HKObjectType.quantityType(forIdentifier: .distanceCycling),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
        
      completion(false, HealthkitSetupError.dataTypeNotAvailable)
      return
    }
    
    let healthKitTypesToWrite: Set<HKSampleType> =                          [activeEnergy,HKObjectType.workoutType()]
    
    let healthKitTypesToRead: Set<HKObjectType> = [activeEnergy,
                                                   stepCount,
                                                   cyclingDistance]
    
    HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                         read: healthKitTypesToRead) { (success, error) in
    completion(success, error)
    }
  }
}
