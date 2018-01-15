//
//  SettingsViewController.swift
//  FitMe
//
//  Created by Chandan Makhija on 29/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var targetStepTF: UITextField!
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveData()
    }
    
    //MARK:- Private Methods
    
    private func initVC() {
        self.navigationItem.title = "Personal Details"
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // Dispay data
    private func showData() {
        nameTF.text = gPersonal.name
        heightTF.text = gPersonal.height
        weightTF.text = gPersonal.weight
        targetStepTF.text = gPersonal.targetStep
    }
    
    // Save perosonal data in core data
    private func saveData() {
        gPersonal.name = nameTF.text
        gPersonal.height = heightTF.text
        gPersonal.weight = weightTF.text
        gPersonal.targetStep = targetStepTF.text
        
        gDataManager.savePersonalData()
    }
    
    //MARK: UITextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        
        return true
    }
    
}
