//
//  File.swift
//  Glaxo
//
//  Created by IN2 MacbookPro on 03/12/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import UIKit

class LogInViewController: ViewControllerWithAutoTextFieldResign, LogInViewDelegate {

    override func viewDidLoad() {
        
        view = UIView.loadFromNibNamed(ViewIdentifier.LogIn)
        
        inputViews = (view as! ViewWithInput).getInputViews()
        
        super.viewDidLoad()
        
        (view as! ViewWithInput).viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        (view as! ViewWithInput).viewDidAppear()
    }
    
    
    /// LogInView delegate
    
    func actionPerformed(action: LogInActions) {
        
        if action == .LogIn{
            
            
            
        }
        
    }
    
}