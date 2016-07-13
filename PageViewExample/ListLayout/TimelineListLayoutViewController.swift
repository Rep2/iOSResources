//
//  TimelineListLayoutViewController.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 06/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import UIKit

class TimelineListLayoutViewController: UIViewController{
    
    @IBOutlet weak var table: IRTableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if refreshState.isRefreshing{
            table.startRefreshAnimation()
        }else{
            table.stopRefresh()
        }
    }
    
    var refreshState: RefreshState!
    
    func setup(refreshState: RefreshState){
        self.refreshState = refreshState
    }
    
    func setTweets(tweets: [TweetSummary]){
        var cells = [IRCellViewModel]()
        
        for tweet in tweets{
            cells.append(createCell(tweet))
        }
        
        table.setData([IRCellViewModelSection(sectionTitle: nil, cellViewModels: cells)])
    }
    
    func setTweet(tweet: TweetSummary, for index:Int){
        let cell = createCell(tweet)
        
        table.setRow(cell, row: index, section: 0)
    }
    
    func addTweets(tweets: [TweetSummary]){
        var cells = [IRCellViewModel]()
        
        for tweet in tweets{
            cells.append(createCell(tweet))
        }
        
        let oldCount = table.cellViewModelSections[0].cellViewModels.count
        
        table.cellViewModelSections[0].cellViewModels.appendContentsOf(cells)
        
        let indexes = (oldCount..<(oldCount + tweets.count)).map { (index) -> NSIndexPath in
            NSIndexPath(forRow: index, inSection: 0)
        }

        table.beginUpdates()
        table.insertRowsAtIndexPaths(indexes, withRowAnimation: .Fade)
        table.endUpdates()
    }
    
    func createCell(tweet: TweetSummary) -> IRCellViewModel{
        return IRCellViewModel(
            implementationIdentifier: IRCellIdentifier.TweetCell,
            data: [
                IRCellElementIdentifiers.TweetAvatar : tweet.userAvatar,
                
                IRCellElementIdentifiers.TweetName : tweet.userName,
                IRCellElementIdentifiers.TweetScreenName : "@" + tweet.userScreenName,
                
                IRCellElementIdentifiers.TweetText : tweet.text,
                
                IRCellElementIdentifiers.TweetDate : tweet.createdDate,
                IRCellElementIdentifiers.TweetExtra : "Favorites: \(tweet.favoritedCount)  |  Retweets: \(tweet.retweetCount)"
            ])
    }
    
    func scrollToIndex(index: Int){
        table.scrollToIndex(index, section: 0)
        table.resetIndex()
    }
    
    func getIndexOfFirstVisibleRow() -> Int?{
        return table.getFirstVisibleRowIndex
    }

}