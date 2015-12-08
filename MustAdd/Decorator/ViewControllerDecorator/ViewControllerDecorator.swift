//
//  ViewControllerDelegate.swift
//  Glaxo
//
//  Created by Rep on 12/7/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import UIKit

class ViewControllerDecorator: NSObject{
    
    private let decorator:ViewControllerDecorator?
    
    init(decorator:ViewControllerDecorator? = nil){
        self.decorator = decorator
    }
    
    func viewDidLoad(element: AnyObject?){
        if let decorator = decorator{
            decorator.viewDidLoad(element)
        }
    }
    
    func viewDidAppear(element: AnyObject?){
        if let decorator = decorator{
            decorator.viewDidAppear(element)
        }
    }
    
}