//
//  Utility.swift
//  FitMe
//
//  Created by Chandan Makhija on 19/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    static var dateTF:UITextField?
    
    //MARK:- Conversion Methods
    
    // Changes time format to hour:minute:second
    class func timeIntervalFormat(interval:TimeInterval)-> String {
        var seconds = Int(interval + 0.5) //round up seconds
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }
    
    // Convert meters to miles
    class func meterToMiles(meters:Double)-> Double {
        let mile = 0.000621371192
        return meters * mile
    }
    
    // Convert mps to kmps
    class func mpsTokmps(mps:NSNumber)->String {
        return String(format: "%.2f", mps.floatValue * 3.6)
    }
    
    // Convert m to km
    class func mToKm(m:NSNumber)->String {
        return String(format: "%.2f", m.floatValue / 1000)
    }
    
    //MARK:- DATE/TIME Methods
    
    // Get current date with time 00:00:01 AM
    class func getTodayStartDay()->Date {
        var calendar = NSCalendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.startOfDay(for: Date())
    }
    
    // Set passed date time to 23:59:59 PM
    class func getEndDateFor(date:Date)->Date {
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.timeZone = TimeZone(abbreviation: "UTC")
        components.hour = 23
        components.second = 59
        components.minute = 59
        
        let dateAtEnd = calendar.date(from: components)
        
        return dateAtEnd!
    }
    
    // get only date component from passed date in string format
    class func getDayString(fromDate:Date)->String {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.timeZone = TimeZone(abbreviation: "UTC")
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDate)
        
        return String(describing: components.day!)
    }
    
    // Get current and last 6 days dates in array of dates
    class func getLastSevenDates()->[Date] {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var dayArr = [Date]()
            
        for _ in 1 ... 7 {
            dayArr.append(date)
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        
        return dayArr
    }
    
    // Get current and last two months in array of strings
    class func getLast3Months()->[String] {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var monthArr = [String]()
        
        for _ in 1 ... 3 {
            var dateString = Utility.string(fromDate: date)
            dateString = dateString.removeHyphenFromString()
            dateString = String(dateString.prefix(6))
            monthArr.append(dateString)
            date = cal.date(byAdding: .month, value: -1, to: date)!
        }
        
        return monthArr.reversed()
    }
    
    // Get current and previous year in array of strings
    class func getYearArr()->[String] {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var yearArr = [String]()
        
        for _ in 1 ... 2 {
            var dateString = Utility.string(fromDate: date)
            dateString = dateString.removeHyphenFromString()
            dateString = String(dateString.prefix(4))
            yearArr.append(dateString)
            date = cal.date(byAdding: .year, value: -1, to: date)!
        }
        
        return yearArr.reversed()
    }

    // Convert date to string
    class func string(fromDate:Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: fromDate)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = kDATE_FORMAT
        
        let stringDate = formatter.string(from: yourDate!)
        
        return stringDate
    }
    
    // Convert String to date format yyyy/mm/dd
    class func date(fromString:String)->Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDATE_FORMAT
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: fromString)
        let cal = Calendar.current
        let sDate = cal.startOfDay(for: date!)
        
        return sDate
    }
    
    // Return last seventh date from today
    class func getLastSeventhDate()->Date {
        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())
        
        return  cal.date(byAdding: .day, value: -7, to: date)!
    }
    
    //MARK:- Alert Methods
    
    // Alert with textfields
    class func showAlertWith(title:String, message:String, placeHolderTF:[String], fromVC:UIViewController, completion:@escaping([UITextField])->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = placeHolderTF[1]
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = placeHolderTF[0]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = kDATE_FORMAT
            textField.text = dateFormatter.string(from: Date())
            Utility.initDatePickerFor(textField: textField)
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            completion((alert?.textFields)!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        fromVC.present(alert, animated: true, completion: nil)
    }
    
    class func initDatePickerFor(textField:UITextField) {
        self.dateTF = textField
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Date()
        textField.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.dateChanged(sender:)), for: .valueChanged)
    }
    
    @objc class func dateChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDATE_FORMAT
        self.dateTF!.text = dateFormatter.string(from: sender.date)
    }
    
    //MARK:- TableView Method
    
    // Used to display message when no cell is available to display
    class func createCellWith(message:String)->UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "EmptyCell")
        cell.textLabel?.text = message
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        
        return cell
    }
}
