//
//  GraphTableCell.swift
//  Woodgroup
//
//  Created by Chandan Makhija on 28/09/17.
//  Copyright © 2017 Woodgroup. All rights reserved.
//

import UIKit

class GraphTableCell: UITableViewCell {

    @IBOutlet weak var lineChartView: LineChart!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addLabelToYAxis()
        setChartProperty()
    }
    
    func setChartProperty() {
        lineChartView.area = true
        lineChartView.x.grid.visible = false
        lineChartView.x.labels.visible = true
        lineChartView.y.grid.visible = false
        lineChartView.y.labels.visible = false
        lineChartView.dots.visible = true
    }
    
    func addLabelToYAxis() {
        let rotateLabel: UILabel = UILabel(frame: CGRect(x:15, y:0, width:28, height:159))
        rotateLabel.textAlignment = .right
        rotateLabel.text = "no of counts"
        rotateLabel.textColor = UIColor.white
        rotateLabel.font = rotateLabel.font.withSize(12)
        self.addSubview(rotateLabel)
        rotateLabel.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double.pi / 2.0)))
        rotateLabel.frame = CGRect(x:2, y:self.frame.midY, width:25, height:self.frame.height)
    }
    
    func setDataToCell(countArr:[CGFloat]?, xLabelArr:[String]?) {
        lineChartView.clearAll()
        
        guard countArr != nil, xLabelArr?.count != 0 else {
            lineChartView.x.labels.visible = false
            lineChartView.addLine([0])
            return
        }
        
        lineChartView.addLine(countArr!)
        lineChartView.x.labels.values = xLabelArr!
    }
}
