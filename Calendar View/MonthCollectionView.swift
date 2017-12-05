//
//  MonthCollectionView.swift
//  Calendar View
//
//  Created by Nitin Bhatia on 04/12/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

protocol CurrentMonth {
   func didMonthChange(monthIndex : Int)
}

class MonthCollectionView: NSObject,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    var delegate : CurrentMonth?
    var monthsArr = ["","January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December",""]
    
    var collectionView : UICollectionView!
    var currentMonthIndex : Int = 1
 
    init(collectionView: UICollectionView){
        self.collectionView = collectionView
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.collectionView.frame.width / 2, height: 80)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        self.collectionView.collectionViewLayout = flowLayout
        currentMonthIndex = Calendar.current.component(.month, from: Date())
       

    }

    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthsArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MonthCell
        cell.lblMonthName.text = monthsArr[indexPath.row]
        
        
        if(currentMonthIndex   == indexPath.row){
            cell.lblMonthName.textColor = UIColor.red
        } else {
            cell.lblMonthName.textColor = UIColor.gray
        }
       
      return cell
  
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        var cell = collectionView.cellForItem(at: visibleIndexPath) as! MonthCell
        cell.lblMonthName.textColor = UIColor.red
        
        
        
        let prevIndexPath : IndexPath = IndexPath(row: visibleIndexPath.row - 1, section: 0)
        cell = collectionView.cellForItem(at: prevIndexPath) as! MonthCell
        cell.lblMonthName.textColor = UIColor.lightGray
        
        let nextIndexPath = IndexPath(row: visibleIndexPath.row + 1, section: 0)
        cell = collectionView.cellForItem(at: nextIndexPath) as! MonthCell
        cell.lblMonthName.textColor = UIColor.lightGray
        
        print(visibleIndexPath.row)
                
        delegate?.didMonthChange(monthIndex: visibleIndexPath.row - 1)
        
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        print(visiblePoint)
        
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        var cell = collectionView.cellForItem(at: visibleIndexPath) as! MonthCell
        cell.lblMonthName.textColor = UIColor.red
        
        
        let prevIndexPath : IndexPath = IndexPath(row: visibleIndexPath.row - 1, section: 0)
        cell = collectionView.cellForItem(at: prevIndexPath) as! MonthCell
        cell.lblMonthName.textColor = UIColor.lightGray
        
        let nextIndexPath = IndexPath(row: visibleIndexPath.row + 1, section: 0)
        cell = collectionView.cellForItem(at: nextIndexPath) as! MonthCell
        cell.lblMonthName.textColor = UIColor.lightGray
        
        print(monthsArr[visibleIndexPath.row - 1])
        
        delegate?.didMonthChange(monthIndex: visibleIndexPath.row)
    }
   

    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsMake(0,25,0,0)
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth - 20

        return CGSize(width: yourWidth, height: yourHeight)
    }

    func scrollToMonthIndex(){
        self.collectionView.scrollToItem(at: IndexPath(row: currentMonthIndex + 1, section: 0), at: UICollectionViewScrollPosition.right, animated: true)
        
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!

        
        let cell = collectionView.cellForItem(at: visibleIndexPath) as! MonthCell
        cell.lblMonthName.textColor = UIColor.red
        
        
      
    }
    
    
    
    
}
