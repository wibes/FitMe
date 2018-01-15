//
//  CoreDataManager.swift
//  FitMe
//
//  Created by Chandan Makhija on 29/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit
import CoreData

let gDataManager = CoreDataManager.sharedInstance

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    
    //MARK:- Core Data methods
    
    func getManagedContext()->NSManagedObjectContext? {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
            return managedContext
    }
    
    func savePersonalData() {
        guard let managedContext = getManagedContext() else {
            return
        }
        
        guard  let result = fetchData(fromEntity: kPERSONAL_ENTITY) else {
            return
        }
        
        let personal:NSManagedObject!
        
        if(result.count == 0) {
            let entity =
            NSEntityDescription.entity(forEntityName: kPERSONAL_ENTITY,
                                       in: managedContext)!
            personal = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        } else {
            personal = result.first
        }
        
            personal.setValue(gPersonal.height, forKeyPath: "height")
            personal.setValue(gPersonal.name, forKeyPath: "name")
            personal.setValue(gPersonal.weight, forKeyPath: "weight")
            personal.setValue(gPersonal.targetStep, forKeyPath: "targetStep")
        
            do {
                try managedContext.save()
                print("Saved")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
    }
    
    func fetchData(fromEntity:String)->[NSManagedObject]? {
        guard let managedContext = getManagedContext() else {
            return nil
        }
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: fromEntity)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func fetchPersonalData() {
        guard  let result = fetchData(fromEntity: kPERSONAL_ENTITY) else {
            return
        }
        for data in result {
            gPersonal.name = data.value(forKey: "name") as? String
            gPersonal.height = data.value(forKey: "height") as? String
            gPersonal.weight = data.value(forKey: "weight") as? String
            gPersonal.targetStep = data.value(forKey: "targetStep") as? String
        }
    }
}
