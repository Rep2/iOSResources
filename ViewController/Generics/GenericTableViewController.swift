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
class GenericTableViewController: UIViewController{
    
    @IBOutlet weak var table: BasicTable!
    
    /// Sections to be displayed
    var sections:[CellSection]!
    
    /// Use decorator to extend functionality
    var decorator:IRViewControllerDecorator?
    
    func initController(controllerTitle:String? = nil, sections: [CellSection], viewControllerDecorator: IRViewControllerDecorator? = nil){
        
        if let title = controllerTitle{
            self.title = title
        }
        
        self.sections = sections
        
        self.decorator = viewControllerDecorator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let decorator = decorator{
            decorator.viewDidLoad(self)
        }
        
        table.sections = sections
    }
    
}
