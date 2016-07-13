//
//  TimelineInteractor.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 05/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import RxSwift

protocol Presenter {
    func onSuccess(elements: Any)
    func onErrror(error: ErrorType)
}

class TimelineInteractor{

    let dateFormaterTo = NSDateFormatter()
    let dateFormaterFrom = NSDateFormatter()
    
    init(){
        dateFormaterTo.dateFormat = "HH:mm:ss dd.MM.yyyy"
        dateFormaterFrom.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
    }

    let disposeBag = DisposeBag()
    
    var isPerformingRequest = false
    
    func performRequest(presenter:TimelinePresenter, for queryParameter: String, forceRefresh: Bool = false){
        
        if !isPerformingRequest{
            
            isPerformingRequest = true
            Context.instance.timelineGateway.getTimeline(for: queryParameter, count: 20, maxID: nil, forceRefresh: forceRefresh)
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
                    
                    self.isPerformingRequest = false
                    presenter.onSuccess(tweetSummaries)
                    
                    }, onError: { (error) in
                        presenter.onErrror(error)
                }).addDisposableTo(disposeBag)
        }
    }
    
    func performAdditionalRequest(presenter:TimelinePresenter, for queryParameter: String, maxID: String, forceRefresh: Bool = false){
        
        if !isPerformingRequest{
            print("new request")
            presenter.addActivityIndicatorFooter()
            
            isPerformingRequest = true
            Context.instance.timelineGateway.getTimeline(for: queryParameter, count: 21, maxID: maxID, forceRefresh: forceRefresh)
                .subscribe(onNext: { (timeline) in
                    
                    var tweetSummaries = [TweetSummary]()
                    
                    var tweets = timeline.tweets
                    tweets.removeAtIndex(0)
                    
                    for tweet in tweets{
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
                    
                    
                    presenter.addCells(tweetSummaries)
                    
                    delay(0.5, closure: {
                        self.isPerformingRequest = false
                    })
                    
                    }, onError: { (error) in
                        presenter.onErrror(error)
                }).addDisposableTo(disposeBag)
        }
    }
    
}