//
//  SqlLiteManager.swift
//  FitMe
//
//  Created by Chandan Makhija on 04/01/18.
//  Copyright © 2018 Chandan Makhija. All rights reserved.
//

import UIKit
import SQLite3

class SqlLiteManager: NSObject {
    
    var databaseHandle:OpaquePointer?
    
    // Get document directory path, where db will be created
    func getDatabasePath()->String {
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)
        
        return dirPaths[0].stringByAppendingPathComponent(
            path: kWATER_DATABASE)
    }
    
    // Open connection and create db table if table is not created
    func initDatabase() {
        let dbPath = getDatabasePath()
        print("Database at: \(dbPath)")
        let databaseAlreadyExists = FileManager.default.fileExists(atPath: dbPath)
        
        if sqlite3_open(dbPath, &databaseHandle) == SQLITE_OK {
            if !databaseAlreadyExists {
                let sqlStatement = "CREATE TABLE IF NOT EXISTS \(kTABLE_NAME) (ID INTEGER PRIMARY KEY AUTOINCREMENT, COUNT INTEGER, DATE TEXT,UNIQUE(DATE) ON CONFLICT REPLACE)"
                
                var createTableStatement: OpaquePointer? = nil
                
                if sqlite3_prepare_v2(databaseHandle, sqlStatement, -1, &createTableStatement, nil) == SQLITE_OK {
                    
                    if sqlite3_step(createTableStatement) == SQLITE_DONE {
                        print("Contact table created.")
                    } else {
                        print("Contact table could not be created.")
                    }
                } else {
                    print("CREATE TABLE statement could not be prepared.")
                }
            
                sqlite3_finalize(createTableStatement)
            }
        }
    }
    
    // Insert all details into db table
    func insertWaterDetail(detail:DailyWaterDetail) {
        var stringDate = Utility.string(fromDate: detail.date!)
        stringDate = stringDate.removeHyphenFromString()
        let sqlStatement = "INSERT OR REPLACE INTO \(kTABLE_NAME) (COUNT, DATE) VALUES ('\(detail.count!)', '\(stringDate)');"
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(databaseHandle, sqlStatement, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                updateWater(detail: detail)
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    // Update detail into db table
    func updateWater(detail:DailyWaterDetail) {
        var stringDate = Utility.string(fromDate: detail.date!)
        stringDate = stringDate.removeHyphenFromString()
        let sqlStatement = "UPDATE \(kTABLE_NAME) SET COUNT = '\(detail.count!)' WHERE DATE LIKE '\(detail.date!)';"
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(databaseHandle, sqlStatement, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("Update statement could not be prepared.")
        }
        sqlite3_finalize(updateStatement)
    }
    
    // Get all rows from db table into model array
    func getWaterDetailArr(sqlStatement:String)->[DailyWaterDetail]? {
        var statement:OpaquePointer? = nil
        
        if (sqlite3_prepare_v2(databaseHandle, sqlStatement, -1, &statement, nil) == SQLITE_OK) {
            var detail = [DailyWaterDetail]()
            while (sqlite3_step(statement) == SQLITE_ROW) {
                let count = Int(sqlite3_column_int(statement, 0))
                let queryResultCol1 = sqlite3_column_text(statement, 1)
                var date = String(cString: queryResultCol1!)
                date = date.insertHyphen()
       
                detail.append(DailyWaterDetail(date: Utility.date(fromString: date), count: count))
            }
            sqlite3_finalize(statement)
            
            return detail
        }
        return nil
    }
    
    //Get maximum count from db where date gets matched with passed dateType
    func getCountSum(forDateType:String)->Int? {
        let sqlStatement = "SELECT SUM(COUNT) FROM \(kTABLE_NAME) WHERE DATE LIKE '\(forDateType)%'"
        var statement:OpaquePointer? = nil
        
        if (sqlite3_prepare_v2(databaseHandle, sqlStatement, -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                let count = Int(sqlite3_column_int(statement, 0))
                
                return count
            }
            sqlite3_finalize(statement)
        }
        
        return nil
    }
    
    // Close db connection
    func closeDatabaseConnection() {
        if sqlite3_close(databaseHandle) == SQLITE_OK {
            print("closed connection")
        } else {
            print("connection not closed")
        }
    }
}
