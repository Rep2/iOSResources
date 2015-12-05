//
//  BasicGet.swift
//  Surveys
//
//  Created by Rep on 11/4/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation
import AFNetworking

class GetHTTPRequest:HTTPRequest{
    
    func startInteraction(clean:Bool = false, params:[String:String]? = nil){
        let getRoute = clean ? route : Routes.instance.baseRoute + route
        
        manager.GET(getRoute,
            parameters: params,
            success: successFunc,
            failure: failureFunc)
    }
    
}