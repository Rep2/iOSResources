//
//  TimelinePresenter.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 07/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import RxSwift

protocol TimelineCollectionPresenterDelegate{
    var isPerformingPaginationRequest: Bool { get }
    
    func isPerformingPaginationRequestObserver() -> Observable<Bool>
}

class TimelineCollectionPresenter{
    
    let controller: TimelineCollectionViewController
    let delegate: TimelineCollectionPresenterDelegate
    
    var data = [TweetSummary]()
    
    let disposeBag = DisposeBag()
    
    init(controller: TimelineCollectionViewController, delegate: TimelineCollectionPresenterDelegate){
        self.controller = controller
        self.delegate = delegate
        
        controller.setDelegte(self)
    }
    
    func newData(elements: [TweetSummary]) {
        data = elements
        
        addImages(elements, startIndex: 0)
        
        controller.setData(elements)
    }
    
    func paginationData(elements: [TweetSummary]){
        addImages(elements, startIndex: data.count)
        
        data.appendContentsOf(elements)
        
        controller.collectionView.reloadData()
    }
    
    func addImages(elements: [TweetSummary], startIndex: Int){
        for (index, tweet) in elements.enumerate(){
            Context.instance.userAvatarGateway.getUserAvatar(for: NSURL(string: tweet.userAvatartLink)!)
                .subscribeNext({ (imageData) in
                    let image = UIImage(data: imageData)!
                    self.data[index + startIndex].userAvatar = image
                    
                    self.controller.updateImage(image, atRow: index + startIndex)
                })
                .addDisposableTo(self.disposeBag)
        }
    }
    
    func onErrror(error: ErrorType) {
        presentAlert("Timeline get failed with error: \(error)", controller: controller)
        controller.endAnimation()
    }
    
    func paginationError(error: ErrorType){
        presentAlert("Timeline update failed with error: \(error)", controller: controller)
    }

}

extension TimelineCollectionPresenter{
    
    var contentHeight: CGFloat{
        return (0..<data.count).reduce(0, combine: {$0 + heightForItemAtIndex($1)}) + footerHeight()
    }
    
    var footerNeeded: Bool{
        return delegate.isPerformingPaginationRequest
    }
    
    func heightForItemAtIndex(index: Int) -> CGFloat{
        let textSize = data[index].text.heightWithConstrainedWidth(controller.view.bounds.width - 32, font: UIFont(name: "HelveticaNeue", size: 15)!)
        return textSize + 95
    }
    
    func footerNeededObserver() -> Observable<Bool> {
        return delegate.isPerformingPaginationRequestObserver()
    }
    
    func footerHeight() -> CGFloat{
        return footerNeeded ? 60 : 0
    }
}

extension TimelineCollectionPresenter: TimelineCollectionDelegate{
    
    func itemForIndex(index: Int) -> TweetSummary {
        return data[index]
    }
    
    var numberOfItems: Int{
        return data.count
    }

    
}