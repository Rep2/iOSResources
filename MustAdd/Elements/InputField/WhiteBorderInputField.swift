//
//  WhiteBorderInputField.swift
//  Glaxo
//
//  Created by IN2 MacbookPro on 03/12/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import Foundation

import UIKit

class WhiteBorderdTextField:UITextField{
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteColor().CGColor
        
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
}