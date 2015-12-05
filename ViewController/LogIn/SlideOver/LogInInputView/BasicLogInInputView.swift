//
//  LogInInputView.swift
//  TComTestApp
//
//  Created by Ivan Rep on 16/09/15.
//  Copyright (c) 2015 Ivan Rep. All rights reserved.
//

import UIKit

/// View used for log in/ sign in input
class BasicLogInInputView:UIView, LogInInputView, UITextFieldDelegate{
    
    /// MARK: elements
    
    @IBOutlet weak var firstLabel: UITextField!
    @IBOutlet weak var secondLabel: UITextField!
    @IBOutlet weak var thirdLabel: BorderdTextField!
    @IBOutlet weak var fourthLabel: BorderdTextField!

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonDistance: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var elementWidth: NSLayoutConstraint!
    
    /// Input view delegate
    var delegate:LogInInputViewDelegate?
    
    let firstTitle = "Log In"
    let secondTitle = "Sign Up"
    
    var logIn:Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        postInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        postInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        elementWidth.constant = ScreenSize.width < 400 ? ScreenSize.width - 40 : 400
    }
    
    func postInit(){
        frame = CGRectMake(0, ScreenSize.height, ScreenSize.width, ScreenSize.height)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "backgroundTapped")
        addGestureRecognizer(gestureRecognizer)
    }
    
    /// Prepeares view for display
    func prepareForDisplay(firstButtonPressed:Bool){
      
        topConstraint.constant = firstButtonPressed ? 160 : 85
        
        thirdLabel.hidden = firstButtonPressed
        fourthLabel.hidden = firstButtonPressed
        
        logIn = firstButtonPressed
        
        button.setTitle(firstButtonPressed ? firstTitle : secondTitle, forState: .Normal)
    }
    
    /// Animations
    
    func show(delay:NSTimeInterval, firstButtonPressed:Bool? = nil){
        if let firstButtonPressed = firstButtonPressed{
            prepareForDisplay(firstButtonPressed)
        }
        
        UIView.animateWithDuration(0.25, delay: delay, options: UIViewAnimationOptions(), animations: {
            self.frame = CGRectMake(0, 0, ScreenSize.width, ScreenSize.height)
            }, completion: {(data:Bool) -> Void in return})
    }
 
    func hide(delay:NSTimeInterval, firstButtonPressed:Bool? = nil){
        if let firstButtonPressed = firstButtonPressed{
            prepareForDisplay(firstButtonPressed)
        }
        
        UIView.animateWithDuration(0.25, delay: delay, options: UIViewAnimationOptions(), animations: {
            self.frame = CGRectMake(0, ScreenSize.height, ScreenSize.width, ScreenSize.height)
        }, completion: {(data:Bool) -> Void in return})
    }
    
    /// Event handlers
    
    @IBAction func odustaniPressed(sender: AnyObject) {
        if let delegate = delegate{
            hide(0)
            delegate.canclePressed()
        }
    }
    
    func backgroundTapped(){
        if firstLabel.isFirstResponder(){
            firstLabel.resignFirstResponder()
        }
        
        if secondLabel.isFirstResponder(){
            secondLabel.resignFirstResponder()
        }
        
        if thirdLabel.isFirstResponder(){
            thirdLabel.resignFirstResponder()
        }
        
        if fourthLabel.isFirstResponder(){
            fourthLabel.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    @IBAction func actionInvoked(sender: AnyObject) {
        
        if checkInput(){
            backgroundTapped()
            
            DimView.instance.addBlureView(true, topIndicatorConstraint: bounds.size.height - 150)
            
            if logIn{
                User.logIn(firstLabel.text!, password: secondLabel.text! , callbackFunc: actionReturn)
            }else{
                User.register(fourthLabel.text!, email: firstLabel.text!, password: secondLabel.text!, callbackFunc: actionReturn)
            }
        }
    }
    
    func actionReturn(success:Bool, data:Any){
        DimView.instance.removeBlurView()
       
        if success{
            if let delegate = delegate{
                if logIn{
                    delegate.actionPerformed(true, isLogIn: self.logIn)
                 //   Alerts.instance.presentAlertWithTitle("Loged in successfully!", message: "")
                }else{
                 //   Alerts.instance.presentAlertWithTitle("Registered successfully!", message: "")
                    delegate.actionPerformed(true, isLogIn: self.logIn)
                }
                
            }
        }
    }
    
    func checkInput() -> Bool{
        
        if firstLabel.text == ""{
            Alerts.instance.presentAlertWithTitle("Field email is required", message: "")
            return false
        }
        
        if secondLabel.text == ""{
            Alerts.instance.presentAlertWithTitle("Field password is required", message: "")
            return false
        }
        
        if !logIn{
            if thirdLabel.text == ""{
                Alerts.instance.presentAlertWithTitle("Field repeat password is required", message: "")
                return false
            }
            
            if secondLabel.text != thirdLabel.text{
                Alerts.instance.presentAlertWithTitle("Passwords do not match", message: "")
                return false
            }
            
            if fourthLabel.text == ""{
                Alerts.instance.presentAlertWithTitle("Field username is required", message: "")
                return false
            }
        }
        
        return true
    }
}
