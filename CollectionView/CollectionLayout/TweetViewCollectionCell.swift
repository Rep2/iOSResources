//
//  TwitterViewCollectionCell.swift
//  EducationalProjectIvanRep
//
//  Created by Undabot Rep on 08/07/16.
//  Copyright © 2016 Undabot. All rights reserved.
//

import Foundation
import UIKit

enum CollectionCells: String{
    case TweetViewCollectionCell = "TweetViewCollectionCell"
}

class TweetViewCollectionCell: UICollectionViewCell{
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var text: UILabel!
    
    @IBOutlet weak var extra: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func prepareForReuse() {
        if let avatar = avatar{
            avatar.image = UIImage(named: "User")!
        }
    }
    
    func setData(tweet: TweetSummary){
        if name != nil{
            if let image = tweet.userAvatar{
                avatar.image = image
            }
            
            name.text = tweet.userName
            screenName.text = "@" + tweet.userScreenName
            
            text.text = tweet.text
            
            extra.text = "Favorited: \(tweet.favoritedCount)  |  Retweets: \(tweet.retweetCount)"
            date.text = tweet.createdDate
        }
    }
    
    func setImage(image: UIImage){
        if avatar != nil{
            avatar.image = image
        }
    }
}