//
//  LogInView.swift
//  Glaxo
//
//  Created by Rep on 12/4/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import UIKit

protocol ViewWithInput{
    func getInputViews() -> [UITextField]
    
    func viewDidLoad()
    func viewDidAppear()
}

class LogInView: UIView, ViewWithInput{
    
    @IBOutlet weak var firstField: WhiteBorderdTextField!
    @IBOutlet weak var secondField: WhiteBorderdTextField!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topInputTextDistanceConstraint: NSLayoutConstraint!
    
    let logoHeightNormal:CGFloat = 140
    let logoHeightBig:CGFloat = 300
    
    let logoHeightWidthRatio:CGFloat = 16/14
    
    let logoHeightSmall:[ScreenSizeType:CGFloat] = [
        .iPhone4 : 60,
        .iPhone5 : 60,
        .iPhone6 : 110,
        .iPhone6Plus : 110
    ]
    
    let topLogoDistanceNormal:CGFloat = 70
    let topLogoDistanceSmall:CGFloat = 30
    
    let inputFieldTopDistanceSmall:CGFloat = 20
    
    let inputFieldTopDistance:[ScreenSizeType:CGFloat] = [
        .iPhone4 : 37,
        .iPhone5 : 50,
        .iPhone6 : 60,
        .iPhone6Plus : 100
    ]
    
    var delegate:LogInViewDelegate?
    
    func getInputViews() -> [UITextField] {
        return [firstField, secondField]
    }
    
    func viewDidLoad() {
        topInputTextDistanceConstraint.constant = inputFieldTopDistance[screenSizeType]!
    }
    
    func viewDidAppear() {
        logoHeightConstraint.constant = logoHeightBig
        logoWidthConstraint.constant = logoHeightBig * logoHeightWidthRatio
        
        UIView.animateWithDuration(0.3, animations: {
            self.layoutIfNeeded()
        })
        
        delay(0.4, closure: {
            
            self.logoHeightConstraint.constant = self.logoHeightNormal
            self.logoWidthConstraint.constant = self.logoHeightNormal * self.logoHeightWidthRatio
            UIView.animateWithDuration(0.3, animations: {
                self.layoutIfNeeded()
            })
        })
    }
    
    
    /// UI Events
    
    @IBAction func textEditingBegin(sender: AnyObject) {
        
        topConstraint.constant = topLogoDistanceSmall
        logoHeightConstraint.constant = logoHeightSmall[screenSizeType]!
        logoWidthConstraint.constant = logoHeightSmall[screenSizeType]! * logoHeightWidthRatio
        
        topInputTextDistanceConstraint.constant = inputFieldTopDistanceSmall
        
        UIView.animateWithDuration(0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    
    @IBAction func textEditingEnd(sender: AnyObject) {
        
        topConstraint.constant = topLogoDistanceNormal
        logoHeightConstraint.constant = logoHeightNormal
        logoWidthConstraint.constant = logoHeightNormal * logoHeightWidthRatio
        
        topInputTextDistanceConstraint.constant = inputFieldTopDistance[screenSizeType]!
        
        UIView.animateWithDuration(0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    
    @IBAction func logInPressed(sender: AnyObject) {
        if let delegate = delegate{
            delegate.actionPerformed(.LogIn)
        }
    }
}