//
//  DataCVCell.swift
//  Calendar View
//
//  Created by Nitin Bhatia on 04/12/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

class DataCVCell: UICollectionViewCell {
    
       override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor=UIColor.clear
            layer.cornerRadius=5
            layer.masksToBounds=true
            
            setupViews()
        }
        
        func setupViews() {
            addSubview(lbl)
            lbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
            lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
            lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
            lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        }
        
        let lbl: UILabel = {
            let label = UILabel()
            label.text = "00"
            label.textAlignment = .center
            label.font=UIFont.systemFont(ofSize: 16)
            label.textColor=Colors.darkGray
            label.translatesAutoresizingMaskIntoConstraints=false
            return label
        }()
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    //get first day of the month
    extension Date {
        var weekday: Int {
            return Calendar.current.component(.weekday, from: self)
        }
        var firstDayOfTheMonth: Date {
            return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        }
    }
    
    //get date from string
    extension String {
        static var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        var date: Date? {
            return String.dateFormatter.date(from: self)
        }
    }
    

