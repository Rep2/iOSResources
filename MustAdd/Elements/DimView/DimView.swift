//
//  BlurView.swift
//  Appbook
//
//  Created by User on 04/08/15.
//  Copyright (c) 2015 iOS pro team. All rights reserved.
//

import UIKit

/// Dim view that can be used by any view
class DimView{
    static let instance = DimView()
    
    var dimView:UIView = {
       let view = UIView(frame: CGRectMake(0, 0, ScreenSize.width, ScreenSize.height))
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        return view
    }()
    
    var indicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(frame: CGRectMake(ScreenSize.width/2-18, 200, 37, 37))
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        indicatorView.hidesWhenStopped = true
        
        return indicatorView
    }()
    
    init(){
        dimView.addSubview(indicator)
    }
    
    
    func addBlureView(animateIndicator:Bool = false, topIndicatorConstraint:CGFloat = 200){
        
        if animateIndicator{
            indicator.startAnimating()
        }else{
            indicator.stopAnimating()
        }
        
        indicator.frame = CGRectMake(ScreenSize.width/2-18, topIndicatorConstraint, 37, 37)
        
        UIApplication.sharedApplication().delegate!.window!!.addSubview(dimView)
        
        self.dimView.alpha = 0
        
        UIView.animateWithDuration(0.3,
            animations: {
                self.dimView.alpha = 1
            })
    }
    
    
    func removeBlurView(){
        indicator.stopAnimating()
       
        delay(0.1, closure: {
            self.dimView.removeFromSuperview()
        })
    }
}