//
//  BordedInputField.swift
//  Glaxo
//
//  Created by IN2 MacbookPro on 03/12/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import UIKit

class BorderdTextField:UITextField{
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
}