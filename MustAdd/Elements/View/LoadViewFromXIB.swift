//
//  LoadViewFromXIB.swift
//  Glaxo
//
//  Created by Rep on 12/4/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import UIKit

enum ViewIdentifier: String{
    case LogIn = "LogInView"
}

extension UIView {
    class func loadFromNibNamed(nibNamed: ViewIdentifier, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed.rawValue,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}