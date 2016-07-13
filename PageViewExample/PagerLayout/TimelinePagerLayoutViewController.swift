//
//  TimelinePagerLayoutViewController.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 06/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import UIKit

class TimelinePagerLayoutViewController: UIPageViewController, UIPageViewControllerDataSource{
    
    var tweets = [TweetSummary]()
    var currentPageIndex = 0
    
    var refreshState:RefreshState!
    
    func setup(refreshState: RefreshState){
        self.refreshState = refreshState
    }
    
    override func viewDidLoad() {
        self.dataSource = self
    }
    
    func prepeareForDisplay(tweets: [TweetSummary], startController: UIViewController, startIndex: Int = 0){
        self.tweets = tweets
        self.currentPageIndex = startIndex

        setViewControllers([startController], direction: .Forward, animated: false, completion: nil)
    }
    
    func setTweet(tweet: TweetSummary, for page: Int){
        tweets[page] = tweet
        
        if let currentPage = getIndexOfCurrentlyDisplayedPage(){
            if currentPage == page{
                setViewControllers([viewForIndex(page)], direction: .Forward, animated: false, completion: nil)
            }
        }
    }
    
    func setIndex(index: Int){
        currentPageIndex = index
        
        setViewControllers([viewForIndex(index)], direction: .Forward, animated: false, completion: nil)
    }
    
    func getIndexOfCurrentlyDisplayedPage() -> Int?{
        return (viewControllers?.last as! TimelinePageLayoutContentViewController).pageIndex
    }
    
    func getCurrentlyDisplayedPage() -> TimelinePageLayoutContentViewController?{
        return (viewControllers?.last as? TimelinePageLayoutContentViewController)
    }
    
    // MARK :: UIPageViewDatasource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! TimelinePageLayoutContentViewController).pageIndex
        
        if index == nil{
            return nil
        }else if index == tweets.count - 1{
            index = 0
        }else{
            index = index! + 1
        }
        
        return viewForIndex(index!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! TimelinePageLayoutContentViewController).pageIndex
        
        if index == nil{
            return nil
        }else if index == 0{
            index = tweets.count - 1
        }else{
            index = index! - 1
        }
        
        return viewForIndex(index!)
    }
    
    
    func viewForIndex(index: Int) -> UIViewController{
        let controller = ViewFactory.instance.getViewController(.PageViewContent) as! TimelinePageLayoutContentViewController
        
        if index >= 0 && index < tweets.count{
            controller.prepareForDisplay(tweets[index], startIndex: index, refreshState: refreshState)
        }else{
            controller.prepareForDisplay(nil, startIndex: index, refreshState: refreshState)
        }

        return controller
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return tweets.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentPageIndex
    }
}