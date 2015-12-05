//
//  ViewController.swift
//  TComTestApp
//
//  Created by Ivan Rep on 16/09/15.
//  Copyright (c) 2015 Ivan Rep. All rights reserved.
//

import UIKit

/// Simple Log In/ Sign up view controller
class LogInViewController: BaseRootViewController, LogInInputViewDelegate, LogInStartViewDelegate {

    // View used as start view
    var startViewProtocol:LogInStartView!
    
    // View used for data input
    var simpleInputView:LogInInputView!
    
    // Inits views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = UIView.loadFromNibNamed(RegisteredViews.LogInStartViewBasic.rawValue, bundle:nil)
        
        startViewProtocol = view as! LogInStartView
        startViewProtocol.delegate = self

        let inputView = UIView.loadFromNibNamed(RegisteredViews.BasicLogInInputView.rawValue, bundle: nil)!
        self.view.addSubview(inputView)
        
        simpleInputView = inputView as! LogInInputView
        simpleInputView.delegate = self
    }

    /// MARK: LogInStartView delegate
    
    func logInPressed() {
        startViewProtocol.hideElements(0)
        
        simpleInputView.show(0.32, firstButtonPressed: true)
    }

    func registerPressed() {        
        startViewProtocol.hideElements(0)
        
        simpleInputView.show(0.32, firstButtonPressed: false)
    }
    
    func facebookPressed() {
        
    }
    
    func googlePressed() {
        
    }
    
    func setViewTitle(title:String){
        navigationItem.title = title
    }
    
    /// MARK: LogInInputView delegate
    
    func canclePressed() {
        setViewTitle("")
        startViewProtocol.showElements(0.32)
    }
    
    func actionPerformed(success:Bool, isLogIn:Bool) {
        LeftSideMenuViewController.instance.loggedIn(User.instance!)
        
        canclePressed()
    }
    
}
