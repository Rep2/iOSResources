//
//  ViewController.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 04/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import UIKit
import RxSwift

protocol RefreshState{
    var isRefreshing: Bool { get }
}

class TimelineViewController: UIViewController, RefreshState {

    @IBOutlet weak var containerView: UIView!
    
    
    var layoutStyle = TimelineLayoutStyle.ListLayout
    
    var containerViewControllers = [TimelineLayoutStyle : UIViewController]()
    
    let disposeBag = DisposeBag()
    
    var tweets: [TweetSummary]!
    
    var wireframe: TimelineWireframe!
    
    var isRefreshing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "RefreshWhite"), style: .Plain, target: self, action: #selector(TimelineViewController.changeLayout))
        
        addLayoutViewController(TimelineLayoutStyle.ListLayout)
        addLayoutViewController(TimelineLayoutStyle.PagerLayout)
        
        addNewContainerView( containerViewControllers[layoutStyle]!, toView: containerView)
        
        let controller = containerViewControllers[TimelineLayoutStyle.ListLayout] as! TimelineListLayoutViewController
        
        controller.table.refreshControllUpdateFunction = {
            self.isRefreshing = true
            controller.table.isRefreshing = true
            
            self.wireframe.updateTimeline()
        }
        
        wireframe.setUpPagination(controller.table.didReachBottomObservable())
    }
    
    func addLayoutViewController(layout: TimelineLayoutStyle){
        let layoutViewController = ViewFactory.instance.getViewController(layout.rawValue)
        
        if let controller = layoutViewController as? TimelinePagerLayoutViewController{
            controller.setup(self)
        }else if let controller = layoutViewController as? TimelineListLayoutViewController{
            controller.setup(self)
        }
        
        containerViewControllers[layout] = layoutViewController
    }
    
    var index = 0
    
    func changeLayout(){
        
        // Fetches index of currently displayed tweets
        if layoutStyle == .ListLayout{
            if let index = (containerViewControllers[layoutStyle]! as! TimelineListLayoutViewController).getIndexOfFirstVisibleRow(){
                self.index = index
            }
        }else if layoutStyle == .PagerLayout{
            if let index = (containerViewControllers[layoutStyle]! as! TimelinePagerLayoutViewController).getIndexOfCurrentlyDisplayedPage(){
                self.index = index
            }
        }
        
        // Changes layout
        let oldLayout = layoutStyle
        
        layoutStyle = oldLayout == .ListLayout ? .PagerLayout : .ListLayout
        
        // Adds new viewController to container
        addNewContainerView( containerViewControllers[layoutStyle]!, toView: containerView)
        
        // Animates layout change
        self.cycleFromViewController(containerViewControllers[oldLayout]!, newViewController: containerViewControllers[layoutStyle]!)
        
        if let controller = (containerViewControllers[layoutStyle]! as? TimelineListLayoutViewController){
            controller.scrollToIndex(index)
        }else if let controller = (containerViewControllers[layoutStyle]! as? TimelinePagerLayoutViewController){
            controller.setIndex(index)
        }
    }
    
    /// Sets data on container view controllers
    func setViewData(tweets: [TweetSummary]){
        isRefreshing = false
        
        if let controller = (containerViewControllers[TimelineLayoutStyle.ListLayout] as? TimelineListLayoutViewController){
            controller.setTweets(tweets)
        }
        
        if let controller = (containerViewControllers[TimelineLayoutStyle.PagerLayout] as? TimelinePagerLayoutViewController){
            let contentController = ViewFactory.instance.getViewController(.PageViewContent) as! TimelinePageLayoutContentViewController
            contentController.prepareForDisplay(tweets[index], startIndex: index, refreshState: self)
            
            controller.prepeareForDisplay(tweets, startController: contentController)
        }
    }
    
    func addData(tweets: [TweetSummary]){
        self.tweets = self.tweets + tweets
        
        if let controller = (containerViewControllers[TimelineLayoutStyle.ListLayout] as? TimelineListLayoutViewController){
            controller.addTweets(tweets)
        }
        
    }
    
    func stopRefresh(){
        isRefreshing = false
        
        if let controller = (containerViewControllers[layoutStyle]! as? TimelineListLayoutViewController){
              controller.table.stopRefresh()
        }else if let controller = (containerViewControllers[layoutStyle]! as? TimelinePagerLayoutViewController){
            if let contentController = controller.getCurrentlyDisplayedPage(){
                contentController.updateActivityIndicator()
            }
        }
    }
    
    func setImage(image: UIImage, for index: Int){
        tweets[index].userAvatar = image
        
        if let controller = (containerViewControllers[TimelineLayoutStyle.ListLayout] as? TimelineListLayoutViewController){
            controller.setTweet(tweets[index], for: index)
        }
        
        if let controller = (containerViewControllers[TimelineLayoutStyle.PagerLayout] as? TimelinePagerLayoutViewController){
            controller.setTweet(tweets[index], for: index)
        }
    }
}