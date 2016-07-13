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

protocol TimelineEventHander{
    func updateTimeline()
    func collectionViewNearBottom()
}

struct TimelineCollectionWireframe: Wireframe, TimelineEventHander{
    
    let view: TimelineCollectionViewController
    let presenter: TimelineCollectionPresenter
    let interactor: TimelineCollectionInteractor
    
    init(){
        view = ViewFactory.instance.getViewController(RegisteredViewControllers.Timeline) as! TimelineCollectionViewController
        
        interactor = TimelineCollectionInteractor()
        
        presenter = TimelineCollectionPresenter(controller: view, delegate: interactor)
        
        interactor.performRequest(presenter, for: "?q=%23ios%20OR%20%23android")
        
        view.setEventHandler(self)
    }
    
    func getView() -> UIViewController{
        return view
    }
    
    func updateTimeline(){
        interactor.performRequest(presenter, for: "?q=%23ios%20OR%20%23android", forceRefresh: true)
    }
    
    func collectionViewNearBottom() {
        let maxID = presenter.itemForIndex(presenter.numberOfItems - 1).id
        
        interactor.performRequest(presenter, for: "?q=%23ios%20OR%20%23android", maxID: maxID, forceRefresh: false)
        
    }

}