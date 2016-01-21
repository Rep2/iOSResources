//
//  Wireframe.swift
//  CUPUSMobilBroker
//
//  Created by IN2 MacbookPro on 20/01/16.
//  Copyright © 2016 IN2. All rights reserved.
//

import UIKit

/// Registerd view controllers of Main storyboard
enum RegisteredViewControllers: String{
    case  Default = "Default"
}

/// Base wireframe. For customization split into multiple
class Wireframe{
    
    static var instance: Wireframe!
    
    var navigationController: UINavigationController!
    
    init(){
        navigationController = BaseNavigationViewController(rootViewController: getViewController(.Default))
        
        Wireframe.instance = self
    }
    
    func getViewController(name: RegisteredViewControllers) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(name.rawValue)
    }
    
}