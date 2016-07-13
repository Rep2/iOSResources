//
//  TimelinePresenter.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 07/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import RxSwift

class TimelinePresenter: Presenter{
    
    let controller: TimelineViewController
    
    init(controller: TimelineViewController){
        self.controller = controller
    }
    
    let disposeBag = DisposeBag()
    
    func onSuccess(elements: Any) {
        
        if let elements = elements as? [TweetSummary]{
            for (index, tweet) in elements.enumerate(){
                Context.instance.userAvatarGateway.getUserAvatar(for: NSURL(string: tweet.userAvatartLink)!)
                    .subscribeNext({ (imageData) in
                        let image = UIImage(data: imageData)!
                        self.controller.setImage(image, for: index)
                    })
                    .addDisposableTo(self.disposeBag)
            }
            
            controller.tweets = elements
            controller.setViewData(elements)
        }
    }
    
    func addCells(tweets: [TweetSummary]){
        controller.addData(tweets)
    }
    
    func onErrror(error: ErrorType) {
        presentAlert("Timeline get failed with error: \(error)", controller: controller)
        
        controller.stopRefresh()
    }
    
    func addActivityIndicatorFooter(){
        let table = (controller.containerViewControllers[TimelineLayoutStyle.ListLayout] as! TimelineListLayoutViewController).table
        table.activityIndicator.startAnimating()
        table.activityIndicator.hidden = false
    }
    
}