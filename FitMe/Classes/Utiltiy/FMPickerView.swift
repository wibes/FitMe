//
//  FMPickerView.swift
//  FitMe
//
//  Created by Chandan Makhija on 02/01/18.
//  Copyright © 2018 Chandan Makhija. All rights reserved.
//

import UIKit

class FMPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerDataSource = [Any]()
    var completionHandler : ( (_ value: Any?) -> (Void))?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame:CGRect.zero)
        self.delegate = self
        self.dataSource = self
    }
    
    
    // MARK:- UIPicker delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView)->Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)->String? {
        let value = pickerDataSource[row] as! String
        return value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard !pickerDataSource.isEmpty else {
            return
        }
        let value = pickerDataSource[row] as! String
        completionHandler!(value)
    }
}

