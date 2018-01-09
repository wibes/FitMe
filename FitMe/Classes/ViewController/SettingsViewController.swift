//
//  SettingsViewController.swift
//  FitMe
//
//  Created by Chandan Makhija on 19/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var targetStepTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveData()
    }
    
    func showData() {
        nameTF.text = gPersonal.name
        heightTF.text = gPersonal.height
        weightTF.text = gPersonal.weight
        targetStepTF.text = gPersonal.targetStep
    }
    
    func saveData() {
        gPersonal.name = nameTF.text
        gPersonal.height = heightTF.text
        gPersonal.weight = weightTF.text
        gPersonal.targetStep = targetStepTF.text
        
        gDataManager.savePersonalData()
    }
}
