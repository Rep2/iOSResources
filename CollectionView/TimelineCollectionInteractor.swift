//
//  TimelineInteractor.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 05/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import RxSwift

class TimelineCollectionInteractor{

    let dateFormaterTo = NSDateFormatter()
    let dateFormaterFrom = NSDateFormatter()
    
    init(){
        dateFormaterTo.dateFormat = "HH:mm:ss dd.MM.yyyy"
        dateFormaterFrom.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
    }

    let disposeBag = DisposeBag()
    
    var isPerformingPagingRequest = Variable(false)
    var pagingRequestDelayed = false
    
    func performRequest(presenter:TimelineCollectionPresenter, for queryParameter: String, maxID: String? = nil, forceRefresh: Bool = false){
        
        guard !(maxID != nil && (isPerformingPagingRequest.value || pagingRequestDelayed)) else { return }
        
        if maxID != nil{
            isPerformingPagingRequest.value = true
        }
        
        Context.instance.timelineGateway.getTimeline(for: queryParameter, count: 20, maxID: maxID, forceRefresh: forceRefresh)
            .subscribe(onNext: { (timeline) in
                
                var tweetSummaries = [TweetSummary]()
                
                for tweet in timeline.tweets{
                    let date = self.dateFormaterFrom.dateFromString(tweet.createdDate)
                    
                    var dateString = tweet.createdDate
                    if let date = date{
                        dateString = self.dateFormaterTo.stringFromDate(date)
                    }
                    
                    tweetSummaries.append(TweetSummary(
                        id: tweet.id,
                        text: tweet.text,
                        createdDate: dateString,
                        retweetCount: tweet.retweetCount,
                        favoritedCount: tweet.favoritedCount,
                        userName: tweet.author.name,
                        userScreenName: tweet.author.screenName,
                        userAvatar: tweet.author.avatar,
                        userAvatartLink: tweet.author.avatarURL))
                }
                
                if maxID != nil{
                    self.isPerformingPagingRequest.value = false
                    presenter.paginationData(tweetSummaries)
                }else{
                    presenter.newData(tweetSummaries)
                }
                
                }, onError: { (error) in
                    
                    if maxID != nil{
                        self.pagingRequestDelayed = true
                        self.isPerformingPagingRequest.value = false
                        presenter.paginationError(error)
                        
                        delay(10, closure: { 
                            self.pagingRequestDelayed = false
                        })
                    }else{
                        presenter.onErrror(error)
                    }
                    
            }).addDisposableTo(disposeBag)
    }
    
}

extension TimelineCollectionInteractor: TimelineCollectionPresenterDelegate{
    
    var isPerformingPaginationRequest: Bool{
        return isPerformingPagingRequest.value
    }
    
    func isPerformingPaginationRequestObserver() -> Observable<Bool>{
        return isPerformingPagingRequest.asObservable()
    }
    
}