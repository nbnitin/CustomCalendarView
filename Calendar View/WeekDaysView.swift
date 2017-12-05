//
//  WeekDaysView.swift
//  Calendar View
//
//  Created by Nitin Bhatia on 04/12/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

struct checkFirstDayofWeek {
    static let firstDayOfWeekIsSunday = true // make it false to make monday is first day of week
}

class WeekDaysView: UIView {
    
    

    override func draw(_ rect: CGRect) {
               
        self.backgroundColor=UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(myStackView)
        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
      
        //if first day of week is sunday
        let daysArr = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        //if first day of week is monday
        let daysArr1 = ["Mo", "Tu", "We", "Th", "Fr", "Sa","Su"]
        
        if(!checkFirstDayofWeek.firstDayOfWeekIsSunday){
            for i in 0..<7 {
                let lbl=UILabel()
                lbl.text=daysArr1[i]
                lbl.textAlignment = .center
                lbl.textColor = Style.weekdaysLblColor
                if(i == 6){
                    lbl.textColor = UIColor.red
                }
                myStackView.addArrangedSubview(lbl)
            }
        } else{
            for i in 0..<7 {
                let lbl=UILabel()
                lbl.text=daysArr[i]
                lbl.textAlignment = .center
                lbl.textColor = Style.weekdaysLblColor
                if(i == 0){
                    lbl.textColor = UIColor.red
                }
                myStackView.addArrangedSubview(lbl)
            }
        }
    }
    
    let myStackView: UIStackView = {
        let stackView=UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints=false
        return stackView
    }()
    
    

}
