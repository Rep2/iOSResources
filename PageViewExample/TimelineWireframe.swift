//
//  TimelineWireframe.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 07/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


struct TimelineWireframe: Wireframe{
    
    let view: TimelineViewController
    let presenter: TimelinePresenter
    let interactor: TimelineInteractor
    
    init(){
        view = ViewFactory.instance.getViewController(.Default) as! TimelineViewController
        
        presenter = TimelinePresenter(controller: view)
        
        interactor = TimelineInteractor()
        interactor.performRequest(presenter, for: "?q=%23ios%20OR%20%23android")
        
        view.wireframe = self
    }
    
    func getView() -> UIViewController{
        return view
    }
    
    func updateTimeline(){
        interactor.performRequest(presenter, for: "?q=%23ios%20OR%20%23android", forceRefresh: true)
    }
    
    let disposeBag = DisposeBag()
    
    func setUpPagination(observable: Observable<Void>){
        observable
            .subscribeNext {
                var maxID:String = ""
                
                if let tweets = self.view.tweets{
                    if let lastTweet = tweets.last{
                        maxID = lastTweet.id
                    }
                }
                
                self.interactor.performAdditionalRequest(self.presenter, for: "?q=%23ios%20OR%20%23android", maxID: maxID, forceRefresh: true)
            }.addDisposableTo(disposeBag)
        
    }
}