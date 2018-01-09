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
    
    class func timeIntervalFormat(interval:TimeInterval)-> String {
        var seconds = Int(interval + 0.5) //round up seconds
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        seconds = seconds % 60
        return String(format:"%02i:%02i:%02i",hours,minutes,seconds)
    }
    
    class func paceString(title:String,pace:Double) -> String{
        var minPerMile = 0.0
        let factor = 26.8224 //conversion factor
        if pace != 0 {
            minPerMile = factor / pace
        }
        let minutes = Int(minPerMile)
        let seconds = Int(minPerMile * 60) % 60
        return String(format: "%@: %02.2f m/s \n\t\t %02i:%02i min/mi",title,pace,minutes,seconds)
    }
    
    class func miles(meters:Double)-> Double {
        let mile = 0.000621371192
        return meters * mile
    }
    
    class func mpsTokmps(mps:NSNumber)->String {
        return String(format: "%.2f", mps.floatValue * 3.6)
    }
    
    class func mToKm(m:NSNumber)->String {
        return String(format: "%.2f", m.floatValue / 1000)
    }
    
    //MARK:- DATE/TIME Methods
    
    class func getTodayStartDay()->Date {
        var calendar = NSCalendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        return calendar.startOfDay(for: Date())
    }
    
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
    
    class func getDayString(fromDate:Date)->String {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.timeZone = TimeZone(abbreviation: "UTC")
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDate)
        
        return String(describing: components.day!)
    }
    
    class func getLast7Dates()->[Date] {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var dayArr = [Date]()
            
        for _ in 1 ... 7 {
            dayArr.append(date)
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        
        return dayArr
    }
    
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

    class func string(fromDate:Date)->String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: fromDate)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = kDATE_FORMAT
        
        let stringDate = formatter.string(from: yourDate!)
        
        return stringDate
    }
    
    class func date(fromString:String)->Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kDATE_FORMAT
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: fromString)
        let cal = Calendar.current
        let sDate = cal.startOfDay(for: date!)
        
        return sDate
    }
    
    class func getLastSeventhDate()->Date {
        let cal = Calendar.current
        let date = cal.startOfDay(for: Date())
        
        return  cal.date(byAdding: .day, value: -7, to: date)!
    }
    
    //MARK:- Alert Methods
    
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
}
