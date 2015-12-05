//
//  LogInViewDelegate.swift
//  Glaxo
//
//  Created by Rep on 12/5/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import Foundation

/// Actions that LogInView can send to it's delegate
enum LogInActions{
    case LogIn
}

/// LogInViewDelegate handles actions that view hands out
protocol LogInViewDelegate{
    
    func actionPerformed(action:LogInActions)
    
}