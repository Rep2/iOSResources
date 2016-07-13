//
//  TimelinePageLayoutContentViewController.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 06/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import UIKit

import RxSwift

class TimelinePageLayoutContentViewController: UIViewController{
    
    @IBOutlet var containingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var extra: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var tweet: TweetSummary?
    var pageIndex: Int?
    
     var refreshState: RefreshState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshData()
    }
    
    func prepareForDisplay(tweet: TweetSummary?, startIndex: Int, refreshState: RefreshState){
        self.refreshState = refreshState
        
        setData(tweet)
        pageIndex = startIndex
    }
    
    func setData(tweet: TweetSummary?, isRefreshing: Bool = false){
        self.tweet = tweet
        
        refreshData()
    }
    
    func updateActivityIndicator(){
        refreshState.isRefreshing ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func refreshData(){
        if let name = name{
            if tweet != nil{
                containingView.hidden = false
                noDataLabel.hidden = true
                
                if !refreshState.isRefreshing{
                    activityIndicator.hidden = true
                }else{
                    activityIndicator.hidden = false
                    
                    activityIndicator.startAnimating()
                }
                
                if let image = tweet!.userAvatar{
                    avatar.image = image
                }else{
                    avatar.image = UIImage(named: "User")!
                }
                
                name.text = tweet!.userName
                screenName.text = "@" + tweet!.userScreenName
                
                text.sizeToFit()
                text.text = tweet!.text
                
                
                extra.text = "Favorites: \(tweet!.favoritedCount)  |  Retweets: \(tweet!.retweetCount)"
                date.text = tweet!.createdDate
            }else{
                containingView.hidden = true
                
                if refreshState.isRefreshing{
                    noDataLabel.hidden = true
                    activityIndicator.hidden = false
                    
                    activityIndicator.startAnimating()
                }else{
                    activityIndicator.hidden = true
                    
                    noDataLabel.hidden = false
                }
            }
        }
    }
}