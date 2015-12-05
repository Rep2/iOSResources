//
//  HTTPRequest.swift
//  Surveys
//
//  Created by Rep on 11/7/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation
import AFNetworking

let manager = AFHTTPRequestOperationManager()

class HTTPRequest{
    
    let route:String
    
    var listener:((Bool, AnyObject) -> Void)?
    

    init(route:String, listener:((Bool, AnyObject) -> Void)? = nil){
        self.route = route
        
        self.listener = listener
    }
    
    func successFunc(operation:AFHTTPRequestOperation, data:AnyObject){
        if let listener = listener{
            listener(true, data)
        }
    }
    
    func failureFunc(operation:AFHTTPRequestOperation?, error:NSError){
        print(error)
        
        print(operation?.responseString)
        
        var errorMessage: (String, String)
        
        if error.code == -1009{
            errorMessage = ("Could not connect to the Internet","Check connection and try again")
        }else{
            if let operation = operation{
            
                // Parse errors from response body
                do {
                    if let jsonDict = try NSJSONSerialization.JSONObjectWithData(error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] as! NSData, options: NSJSONReadingOptions.MutableContainers) as? [String:AnyObject]{
                        
                        
                    }
                    
                    
                }catch let parseError {
                    print(parseError)
                }
                
                
                if let response = operation.response{
                    errorMessage = ("Error with status code \(response.statusCode)","")
                }else{
                    errorMessage = ("Error without a error code","")
                }
            }else{
                errorMessage = ("Request did not return valid response","")
            }
        }
        
        Alerts.instance.presentAlertWithTitle(errorMessage.0, message: errorMessage.1)
        
        if let listener = listener{
            listener(false, errorMessage.0)
        }
    }
    
    static func setSessionHeader(value:String?, field:String){
    
        manager.responseSerializer = AFJSONResponseSerializer()
        
        manager.requestSerializer.setValue(value, forHTTPHeaderField: field)
    }
    
    static func setJson(){
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}