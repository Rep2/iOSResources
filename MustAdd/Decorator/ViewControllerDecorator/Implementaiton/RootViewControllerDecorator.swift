//
//  File.swift
//  Glaxo
//
//  Created by Rep on 12/7/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import UIKit

class RootViewControllerDecorator: ViewControllerDecorator{
    
    override func viewDidLoad(element: AnyObject?) {
        super.viewDidLoad(element)
        
        let leftButton = UIBarButtonItem(image: UIImage(named: "Menu"), style: .Plain, target: self, action: "leftBarButtonPressed")
        
        if let controller = element as? UIViewController{
            controller.navigationItem.leftBarButtonItem = leftButton
            
            controller.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain , target: nil, action: nil)
        }
    }
    
    func leftBarButtonPressed(){
        Wireframe.instance.sideMenuOpen()
    }
    
}