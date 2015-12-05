//
//  PostHTTPRequest.swift
//  Surveys
//
//  Created by Rep on 11/12/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation
import AFNetworking

class PostHTTPRequest:HTTPRequest{
    
    func startInteraction(clean:Bool = false, params:[String:AnyObject]){
        let getRoute = clean ? route : Routes.instance.baseRoute + route
        
        manager.POST(getRoute,
            parameters: params,
            success: successFunc,
            failure: failureFunc)
    }
    
}