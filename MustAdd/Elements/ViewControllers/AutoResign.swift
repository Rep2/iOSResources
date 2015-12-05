//
//  AutoResign.swift
//  Glaxo
//
//  Created by IN2 MacbookPro on 03/12/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerWithAutoTextFieldResign:UIViewController, UITextFieldDelegate{
    
    var inputViews:[UITextField]!
    
    override func viewDidLoad() {
        for inputView in inputViews{
            inputView.delegate = self
        }
        
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapped")
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    func backgroundTapped(){
        for inputView in inputViews{
            inputView.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
        
    }
    
}