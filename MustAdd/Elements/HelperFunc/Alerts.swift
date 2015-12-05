//
//  Alerts.swift
//  Appbook
//
//  Created by User on 10/06/15.
//  Copyright (c) 2015 iOS pro team. All rights reserved.
//

import UIKit

class Alerts:NSObject, UIAlertViewDelegate{

    static var instance = Alerts()
    
    let appDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    override init(){
         appDelegate.window!.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        
        
    }
    
    var action:((AnyObject)->Void)?
    
    
    func presentAlertWithTitle(title:String? = nil, message:String? = nil, twoButtons:Bool = false, defaultButtonTitle:String? = nil, confirmButtonTitle:String? = nil, buttonAction:((AnyObject)->Void)? = nil){
        
  
            let controller = Wireframe.instance.getCurrentViewController()
            
            let alertController: UIAlertController
        
        if UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiom.Pad{
            alertController = UIAlertController(title:title,
                message: message,
                preferredStyle: UIAlertControllerStyle.ActionSheet)
        }else{
            alertController = UIAlertController(title:title,
                message: message,
                preferredStyle: UIAlertControllerStyle.Alert)
        }
        
            
            if twoButtons{
                alertController.addAction(UIAlertAction(title: confirmButtonTitle ?? "Da", style: .Default, handler: {action -> Void in
                    if let buttonAction = buttonAction{
                        buttonAction(true)
                    }
                }))
                alertController.addAction(UIAlertAction(title: defaultButtonTitle ?? "Ne", style: .Default, handler: {action -> Void in
                    if let buttonAction = buttonAction{
                        buttonAction(false)
                    }
                }))
            }else{
                alertController.addAction(UIAlertAction(title: defaultButtonTitle ?? "OK", style: UIAlertActionStyle.Cancel, handler: {action -> Void in
                    
                    if let buttonAction = buttonAction{
                        buttonAction(true)
                    }
                    
                    }))
            }
        
           // alertController.popoverPresentationController!.sourceView = controller.view
            //alertController.popoverPresentationController!.sourceRect = CGRectMake(controller.view.bounds.size.width / 2.0, controller.view.bounds.size.height / 2.0, 1.0, 1.0)
            
            controller.presentViewController(alertController, animated:true, completion: nil)
    }
    
    func presentInputAlert(title:String, message:String = "", buttonTitle:String? = nil , buttonAction:((Bool, String?)->Void)? = nil){
            let controller = Wireframe.instance.getCurrentViewController()
            
            let alertController = UIAlertController(title:title,
                message: message,
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = ""
            })
            
            alertController.addAction(UIAlertAction(title: buttonTitle ?? "Unesi", style: .Default, handler: {(action) -> Void in
                let textField = alertController.textFields![0]
                
                if let buttonAction = buttonAction{
                    buttonAction(true, textField.text)
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "Odustani", style: UIAlertActionStyle.Cancel, handler: {action -> Void in
                if let buttonAction = buttonAction{
                    buttonAction(false, nil)
                }
                }))
            
            controller.presentViewController(alertController, animated:true, completion: nil)
 
    }

}

