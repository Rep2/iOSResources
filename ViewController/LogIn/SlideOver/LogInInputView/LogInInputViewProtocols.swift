//
//  LogInInputViewProtocols.swift
//  Surveys
//
//  Created by Rep on 11/7/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

/// Delegate which listens to events
protocol LogInInputViewDelegate{
    
    /// Called on action pressed
    func actionPerformed(success:Bool, isLogIn:Bool)
    
    /// Called on cancle pressed
    func canclePressed()
}

protocol LogInInputView{
    
    var delegate:LogInInputViewDelegate? {get set}
    
    /// Shows view
    func show(delay:NSTimeInterval, firstButtonPressed:Bool?)
    
    /// Hides view
    func hide(delay:NSTimeInterval, firstButtonPressed:Bool?)
}