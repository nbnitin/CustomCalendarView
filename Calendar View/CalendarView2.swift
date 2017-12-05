//
//  CalendarView2.swift
//  Calendar View
//
//  Created by Nitin Bhatia on 04/12/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

class CalendarView2: UIViewController,CurrentMonth,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource {
    
    

    @IBOutlet weak var monthCollectionView: UICollectionView!
    var MonthCollection : MonthCollectionView!
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    
    var sundayIndex = 0
    var customDatePicker: UIPickerView!
    var customDateArray : [String] = []
    
    
    var firstDayOfWeek = 3 // 2 if sunday or make it 3 if first day of week is monday
    var colorOfFirstDayOfWeek = 0
    
    @IBOutlet weak var myCalendarView: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1900...2050{
            customDateArray.append("\(i)")
        }
        
        
        MonthCollection = MonthCollectionView(collectionView: monthCollectionView)
        
        MonthCollection.delegate = self
        
        monthCollectionView.delegate = MonthCollection
        monthCollectionView.dataSource = MonthCollection
        
        
        customDatePicker = UIPickerView(frame: CGRect(x:10, y:0, width:250, height:200))
        customDatePicker.delegate = self
        customDatePicker.dataSource = self
        
        setTheme(theme:MyTheme.dark)
        initializeView()
        setFirstDayOfMonth()

        // Do any additional setup after loading the view.
    }
    
   override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    MonthCollection.scrollToMonthIndex()
    let index = customDateArray.index(of: "\(currentYear)")
    customDatePicker.selectRow(index!, inComponent: 0, animated: true)
    }
    
    func setFirstDayOfMonth(){
        if(checkFirstDayofWeek.firstDayOfWeekIsSunday){
            firstDayOfWeek = 2
            colorOfFirstDayOfWeek = 7
        } else{
            firstDayOfWeek = 3
            colorOfFirstDayOfWeek = 6
        }
        self.title = "\(currentYear)"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        
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
            let calcDate = indexPath.row-firstWeekDayOfMonth + firstDayOfWeek
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
    
    func didYearChange(){
        self.view.becomeFirstResponder()
        let index = self.customDatePicker.selectedRow(inComponent: 0)
        self.currentYear = Int(self.customDateArray[index])!
        firstWeekDayOfMonth = getFirstWeekDay()
        setFirstDayOfMonth()
        myCalendarView.reloadData()
    }
    
    func didMonthChange(monthIndex: Int) {
        currentMonthIndex=monthIndex+1
        firstWeekDayOfMonth=getFirstWeekDay()
        setFirstDayOfMonth()
        myCalendarView.reloadData()
    }
    
    func setTheme(theme : MyTheme){
        if theme == .dark {
            Style.themeDark()
        } else {
            Style.themeLight()
        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return customDateArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return customDateArray[row]
    }
    
    


    @IBAction func changeYear(_ sender: Any) {
        let alertView = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
          let height:NSLayoutConstraint = NSLayoutConstraint(item: alertView.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
        alertView.view.addConstraint(height)
        
        
         alertView.view.addSubview(customDatePicker)
        
        let actionDone = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            self.didYearChange()
            
            
            
        })
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        
        alertView.addAction(actionDone)
        alertView.addAction(actionCancel)
        present(alertView, animated: true, completion: nil)
    }
    
    
}
