//
//  GenericRefreshTableViewController.swift
//  Appbook
//
//  Created by IN2 MacbookPro on 04/01/16.
//  Copyright © 2016 iOS pro team. All rights reserved.
//

import Foundation

class GenericRefreshTableViewController: ViewControllerWithDecorator{
    
    @IBOutlet weak var table: TableWithRefresh!
    
    var sections:[GenericSection]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.beginRefresh()
        
        if let sections = sections{
            table.sections = sections
            stopRefresh()
        }else{
            table.sections = []
        }
    }
    
    func setSections(sections:[GenericSection]){
        self.sections = sections
        
        if table != nil{
            table.sections = sections
            table.reloadData()
            table.endRefresh()
        }
    }
    
    func stopRefresh(){
        table.endRefresh()
    }
    
}