//
//  File.swift
//  Glaxo
//
//  Created by IN2 MacbookPro on 03/12/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import Foundation

enum ScreenSizeType{
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6Plus
}

func getScreenSizeType() -> ScreenSizeType{
    
    if ScreenSize.height == 480{
        return .iPhone4
    }else if ScreenSize.height == 568{
        return .iPhone5
    }else if ScreenSize.height == 667{
        return .iPhone6
    }else {
        return .iPhone6Plus
    }
    
}