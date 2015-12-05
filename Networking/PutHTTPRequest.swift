//
//  PutHTTPRequest.swift
//  Surveys
//
//  Created by Rep on 11/24/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation
import AFNetworking

class PutHTTPRequest:HTTPRequest{
    
    func startInteraction(clean:Bool = false, params:[String:String]){
        let getRoute = clean ? route : Routes.instance.baseRoute + route
        
        manager.PUT(getRoute,
            parameters: params,
            success: successFunc,
            failure: failureFunc)
        
    }
    
    func startJSONInteraction(clean:Bool = false, params:AnyObject){
        let getRoute = clean ? route : Routes.instance.baseRoute + route
        
         manager.PUT(getRoute,
            parameters: params,
            success: successFunc,
            failure: failureFunc)
    }
    
}