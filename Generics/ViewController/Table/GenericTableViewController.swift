//
//  GenericTableViewController.swift
//  Glaxo
//
//  Created by Rep on 12/7/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import UIKit

/**
    Generic UIViewController inmplementing BasicTable
*/
class GenericTableViewController: ViewControllerWithDecorator{
    
    @IBOutlet weak var table: GenericTable!
    
    var sections:[GenericSection]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.sections = sections
    }
    
    func setSections(sections:[GenericSection]){
        self.sections = sections
        
        if table != nil{
            table.sections = sections
            table.reloadData()
        }
    }
}
