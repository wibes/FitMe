//
//  StepCalculater.swift
//  FitMe
//
//  Created by Chandan Makhija on 19/12/17.
//  Copyright © 2017 Chandan Makhija. All rights reserved.
//

import UIKit
import CoreMotion

class StepCalculater: UIViewController {

    @IBOutlet weak var goalLbl: UILabel!
    @IBOutlet weak var totalStepLbl: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var startStopBtn: UIButton!
    @IBOutlet weak var progressView:MFRoundProgressView!
    
    // timers
    var timer = Timer()
    let timerInterval = 1.0
    var timeElapsed:TimeInterval = 0.0
    
    //MARK:- LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkTodayTotalStep()
    }
    
    // MARK:- Private Methods
    
    private func checkTodayTotalStep(){
        gCoreMotionManager.getPedometerData(fromDate: Utility.getTodayStartDay(), toDate: Date()) { (data) in
            self.totalStepLbl.text = String(describing: data.numberOfSteps)
            self.updateProgressBar()
        }
    }
    
    private func initUI() {
        if let target = gPersonal.targetStep {
            self.goalLbl.text = "Take \(target) steps a day"
        }
        
        self.navigationItem.title = "Track your steps"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        makeBtnRound()
    }
    
    private func makeBtnRound() {
        startStopBtn.layer.cornerRadius = startStopBtn.frame.width/2
        startStopBtn.clipsToBounds = true
    }
    
    //Timer functions
    private func startTimer() {
        if timer.isValid { timer.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: timerInterval,target: self,selector: #selector(timerAction(timer:)) ,userInfo: nil,repeats: true)
    }
    
    @objc func timerAction(timer:Timer){
        showTimeElapsed()
    }
    
    private func stopTimer(){
        timer.invalidate()
        timeElapsed = 0.0
        timeLbl.text = Utility.timeIntervalFormat(interval: timeElapsed)
    }
    
    private func showTimeElapsed() {
        timeElapsed += self.timerInterval
        timeLbl.text = Utility.timeIntervalFormat(interval: timeElapsed)
    }
    
    //Start Pedometer update
    private func startPedometer() {
        startTimer()
        gCoreMotionManager.startPedometerUpdate(from: Date()) { (pedoData,error) in
            guard pedoData != nil else {
                self.stopTimer()
                return
            }
            self.setDataFrom(pedData: pedoData!)
        }
    }
    
    //Stop pedometer update
    private func stopPedometer() {
        stopTimer()
        checkTodayTotalStep()
        gCoreMotionManager.stopPedometerUpdate()
    }
    
    private func setDataFrom(pedData:CMPedometerData) {
        self.stepLabel.text = String(describing: pedData.numberOfSteps)
        if let step = pedData.distance {
            self.distanceLabel.text = Utility.mToKm(m: step)
            
            // Update progree bar
            updateProgressBar()
        }
        if let pace = pedData.currentPace {
            self.paceLabel.text = Utility.mpsTokmps(mps: pace)
        }
    }
    
    private func updateProgressBar() {
        guard let goalString = gPersonal.targetStep else {return}
        if let goal = Int(goalString), let totalStepTaken = Int(totalStepLbl.text!) {
            progressView.percent = CGFloat((Float(totalStepTaken) / Float(goal)) * 100)
        }
    }
    
    //MARK:- IBAction Method
    
    @IBAction func startStopAction(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Start" {
            startPedometer()
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = UIColor.red
        } else {
            stopPedometer()
            sender.backgroundColor = UIColor.green
            sender.setTitle("Start", for: .normal)
        }
    }
}
