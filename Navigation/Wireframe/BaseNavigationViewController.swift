//
//  BaseNavigationViewController.swift
//  CUPUSMobilBroker
//
//  Created by Rep on 1/21/16.
//  Copyright © 2016 IN2. All rights reserved.
//

import UIKit

/// Navigation controller used by wireframe
class BaseNavigationViewController: UINavigationController{
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        postInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        postInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// Customizes navigation controller
    func postInit(){
        customizeNavigationBar()
    }
    
    func customizeNavigationBar(){
        navigationBar.barTintColor = UIColor(red: 0, green: 122.0/255, blue: 1, alpha: 1)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    
}
