//
//  LogInStartingView.swift
//  TComTestApp
//
//  Created by Ivan Rep on 17/10/15.
//  Copyright © 2015 Ivan Rep. All rights reserved.
//

import UIKit

/**
Simple view used as starting log in view
*/
class LogInStartViewBasic:UIView, LogInStartView{
    
    /// MARK: Animation
    
    // Constraints used for animation
    @IBOutlet weak var bottomButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var elementWidth: NSLayoutConstraint!
    
    // Values used for animation. Change for differen element position
    let bottomConstraintHidden:CGFloat = -300
    let bottomConstraintShown:CGFloat = ScreenSize.height < 568 ? 18 : 33
    
    let topConstraintHidden:CGFloat = -130
    let topConstraintShown:CGFloat = ScreenSize.height > 568 ? 127 : (ScreenSize.height < 568 ? 70 : 100)
    
    let middleConstraintConstant:CGFloat = ScreenSize.height < 568 ? 30 : 46
    
    // Views delegate
    var delegate:LogInStartViewDelegate?
    
    override func awakeFromNib() {
        titleTopConstraint.constant = topConstraintShown
        bottomButtonConstraint.constant = bottomConstraintShown
        middleConstraint.constant = middleConstraintConstant
     
        elementWidth.constant = ScreenSize.width < 400 ? ScreenSize.width - 40 : 400
    }
    
    
    /** Shows views elements
     - parameters delay: Time after which animation starts
     */
    func showElements(delay:NSTimeInterval){
        bottomButtonConstraint.constant = bottomConstraintShown
        titleTopConstraint.constant = topConstraintShown
        
        UIView.animateWithDuration(0.25, delay: delay, options: UIViewAnimationOptions(), animations: {
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    /** Hides views elements
    - parameters delay: Time after which animation starts
    */
    func hideElements(delay:NSTimeInterval){
        bottomButtonConstraint.constant = bottomConstraintHidden
        titleTopConstraint.constant = topConstraintHidden
        
        UIView.animateWithDuration(0.25, delay: delay, options: UIViewAnimationOptions(), animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    /// Notifies observer on log in pressed
    @IBAction func logInPressed(sender: AnyObject) {
        if let delegate = delegate{
            delegate.setViewTitle("Log In")
            delegate.logInPressed()
        }
    }
    
    /// Notifies observer on register pressed
    @IBAction func registerPressed(sender: AnyObject) {
        if let delegate = delegate{
            delegate.setViewTitle("Sign Up")
            delegate.registerPressed()
        }
    }
   
    /// Notifies observer on facebook log in pressed
    @IBAction func facebookPressed(sender: AnyObject) {
        if let delegate = delegate{
            delegate.registerPressed()
        }
    }
    
    /// Notifies observer on google log in pressed
    @IBAction func googlePressed(sender: AnyObject) {
        if let delegate = delegate{
            delegate.registerPressed()
        }
    }
    
    
}