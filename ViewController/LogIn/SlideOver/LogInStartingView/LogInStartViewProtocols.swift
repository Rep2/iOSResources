//
//  LogInStartViewProtocols.swift
//  Surveys
//
//  Created by Rep on 11/6/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

/// Log in start view delegate
/// Handles events from start view
protocol LogInStartViewDelegate{
    
    /// Called when log in is pressed
    func logInPressed()

    /// Called when register is pressed
    func registerPressed()
    
    /// Called when faceboook is pressed
    func facebookPressed()
    
    /// Called when google is pressed
    func googlePressed()
    
    func setViewTitle(title:String)
}

/// Log in start view protocol
protocol LogInStartView{
    
    /// View delegate. See LogInStartViewDelegate
    var delegate: LogInStartViewDelegate? {get set}
    
    /* Presents view elements
    - parameter delay: Time after which animations start
    */
    func showElements(delay:NSTimeInterval)
    
    /* Hides view elements
    - parameter delay: Time after which animations start
    */
    func hideElements(delay:NSTimeInterval)
}