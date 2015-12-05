//
//  GetImage.swift
//  Surveys
//
//  Created by Rep on 11/7/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import UIKit

func getImage(url:String, observer:(UIImage?) -> Void){
    if let url = NSURL(string: url) {
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let data = data{
                    return observer(UIImage(data: data))
                }
        })
        
    }
}