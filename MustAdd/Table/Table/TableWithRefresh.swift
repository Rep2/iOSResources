//
//  TableWithRefresh.swift
//  Appbook
//
//  Created by User on 04/08/15.
//  Copyright (c) 2015 iOS pro team. All rights reserved.
//

import UIKit

class TableWithRefresh:BasicTable{

    let refresh = UIRefreshControl()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(refresh)
        
        noDataShow = {(data:AnyObject) -> Bool in
            return (data as! [CellSection]).count == 0 && !self.refresh.refreshing
        }
    }
    
    func beginRefresh(){
        contentOffset = CGPointMake(0, -refresh.bounds.size.height)
        refresh.beginRefreshing()

    }
    
    func endRefresh(){
        refresh.endRefreshing()
  
        if sections.count == 0{
            setContentOffset(CGPointZero, animated: false)
        }else{
            setContentOffset(CGPointZero, animated: true)
        }

    }
    
    func endRefresh(animated:Bool){
        refresh.endRefreshing()
        
        setContentOffset(CGPointZero, animated: animated)
    }

}