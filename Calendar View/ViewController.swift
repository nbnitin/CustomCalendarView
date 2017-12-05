//
//  ViewController.swift
//  Calendar View
//
//  Created by Nitin Bhatia on 04/12/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

enum MyTheme{
    case dark
    case light
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]


    @IBOutlet weak var weekDaysView: WeekDaysView!
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var myCalendarView: UICollectionView!
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    
    var sundayIndex = 0
    
    
    
   var firstDayOfWeek = 3 // 2 if sunday or make it 3 if first day of week is monday
    var colorOfFirstDayOfWeek = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFirstDayOfMonth()
        
       
        
        // Do any additional setup after loading the view, typically from a nib.
        
        btnNext.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btnPrev.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        setTheme(theme:MyTheme.dark)
        initializeView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFirstDayOfMonth(){
        if(checkFirstDayofWeek.firstDayOfWeekIsSunday){
            firstDayOfWeek = 2
            colorOfFirstDayOfWeek = 7
        } else{
            firstDayOfWeek = 3
            colorOfFirstDayOfWeek = 6
        }
    }
    
    
    @objc func btnLeftRightAction(sender: UIButton) {
        if sender == btnNext {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 1
                currentYear += 1
            }
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex <= 0 {
                currentMonthIndex = 12
                currentYear -= 1
            }
        }
        
        
        setFirstDayOfMonth()
        lblMonth.text="\(monthsArr[currentMonthIndex - 1]) \(currentYear)"
        firstWeekDayOfMonth=getFirstWeekDay()
        myCalendarView.reloadData()
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        lblMonth.text = monthsArr[currentMonthIndex - 1]
        
        myCalendarView.delegate=self
        myCalendarView.dataSource=self
        myCalendarView.register(DataCVCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(!checkFirstDayofWeek.firstDayOfWeekIsSunday){
            return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 2
        }
        return numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1


    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(checkFirstDayofWeek.firstDayOfWeekIsSunday){
            let rem = indexPath.row % colorOfFirstDayOfWeek
            
            if(rem == 0){
                sundayIndex = 0
            } else{
                sundayIndex += 1
            }
       } else{
            if (indexPath.row == colorOfFirstDayOfWeek){
                sundayIndex = 0
                colorOfFirstDayOfWeek += 7
            } else {
                sundayIndex = 1
            }
        }
        
        
        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DataCVCell
        cell.backgroundColor=UIColor.clear
        
       
        if indexPath.item <= firstWeekDayOfMonth - firstDayOfWeek {
            cell.isHidden=true
            
        } else {
            
            
            
            let calcDate = indexPath.item-firstWeekDayOfMonth + firstDayOfWeek
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            
            
            
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.isUserInteractionEnabled=false
                cell.lbl.textColor = UIColor.lightGray
            } else {
                cell.isUserInteractionEnabled=true
                cell.lbl.textColor = Style.activeCellLblColor
                

                
            }
            
            if(sundayIndex == 0){
                cell.lbl.textColor = UIColor.red
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=Colors.darkRed
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor=UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor=UIColor.clear
        let lbl = cell?.subviews[1] as! UILabel
        lbl.textColor = Style.activeCellLblColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7 - 8
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func getFirstWeekDay() -> Int {
        //if sunday is not first day of week
        if(!checkFirstDayofWeek.firstDayOfWeekIsSunday){
            let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
       
            if(day == 1){
                return 8
            }
            
            return day == 7 ? 7 : day
        }
        
        //if sunday is first day of week
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        return day == 7 ? 7 : day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex+1
        currentYear = year
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        myCalendarView.reloadData()
        
//        monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
    
    func setTheme(theme : MyTheme){
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
    }

}

