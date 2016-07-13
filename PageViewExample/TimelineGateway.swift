//
//  TimelineGateway.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 05/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol TimelineGateway{
    func getTimeline(for queryParameter: String, count:Int, maxID: String?, forceRefresh: Bool) -> Observable<Timeline>
}

class TimelineMasterGateway: TimelineGateway{
    
    let localGateway: TimelineRepository
    let webGateway: TimelineWebGateway
    
    init(){
        localGateway = TimelineRepository()
        webGateway = TimelineWebGateway()
    }
    
    func getTimeline(for queryParameter: String, count:Int = 20, maxID: String? = nil, forceRefresh: Bool = false) -> Observable<Timeline> {
        return Observable
            .of(
                localGateway.getTimeline(for: queryParameter, count: count, maxID: maxID, forceRefresh: forceRefresh)
                    .observeOn(MainScheduler.instance),
                
                webGateway.getTimeline(for: queryParameter, count: count, maxID: maxID, forceRefresh: forceRefresh)
                    .observeOn(MainScheduler.instance)
                    .doOnNext({ (timeline) in
                        self.localGateway.setTimeline(timeline)
                     }))
            .concat()
            .observeOn(MainScheduler.instance)
            .take(1)
    }
}

class TimelineWebGateway: TimelineGateway{
    
    func getTimeline(for queryParameter: String, count:Int = 20, maxID: String? = nil, forceRefresh: Bool = false) -> Observable<Timeline> {
            return TwitterAccessTokenInteractor.instance.getAccessToken()
                .take(1)
                .flatMap({ (token: TwitterAccessToken) -> Observable<Timeline> in
                    var URLParameters = queryParameter
                    
                    if let maxID = maxID{
                        URLParameters += "&max_id=" + maxID
                    }
                    
                    let request = Alamofire.request(.GET,
                        NSURL(string: WebRoutes.TwitterTimelineSearch.rawValue + URLParameters)!,
                        headers: ["Authorization" : "Bearer " + token.accessToken])
                    
                    return performWebResourceRequest(request)
                })
    }
}

class TimelineRepository: TimelineGateway{
    
    var timeline: Timeline?
    
    func getTimeline(for queryParameter: String, count:Int = 20, maxID: String? = nil, forceRefresh: Bool = false) -> Observable<Timeline> {
        guard !forceRefresh && maxID == nil else { return Observable.empty() }
        
        if let timeline = timeline{
            return Observable.just(timeline)
        }else{
            return Observable.empty()
        }
    }
    
    func setTimeline(timeline: Timeline){
        self.timeline = timeline
    }
}