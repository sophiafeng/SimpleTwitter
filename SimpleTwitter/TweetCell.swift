//
//  TweetCell.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/15/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    var tweet: Tweet?

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var retweeterImage: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBAction func onRetweetButton(_ sender: RetweetButton) {
        print("retweet button tapped")
        if(sender.isSelected) {
            // deselect
            sender.isSelected = false
            tweet?.retweeted = false
            retweetCountLabel.text = String(describing: (tweet?.retweetCount)!)
        } else {
            // select with animation
            sender.isSelected = true
            tweet?.retweeted = true
            retweetCountLabel.text = String(describing: (tweet?.retweetCount)!)
        }
    }
    @IBAction func onFavoriteButton(_ sender: FavoriteButton) {
        print("favorite button tapped")
        if(sender.isSelected) {
            // deselect
            sender.isSelected = false
            tweet?.favorited = false
            favoriteCountLabel.text = String(describing: (tweet?.favoritesCount)!)
        } else {
            // select with animation
            sender.isSelected = true
            tweet?.favorited = true
            favoriteCountLabel.text = String(describing: (tweet?.favoritesCount)!)
        }
    }
    
    func buildCellWithTweet(tweet: Tweet) {
        self.tweet = tweet
        
        if let userImageUrl = tweet.user?.profileUrl {
            userImage.setImageWith(userImageUrl, placeholderImage: #imageLiteral(resourceName: "twitter_icon"))
            userImage.layer.cornerRadius = 5
            userImage.clipsToBounds = true
        }
        
        //@(todo) put in utility
        if (tweet.retweeterHandle != nil) {
            retweeterImage.image = #imageLiteral(resourceName: "twitter_retweet_icon")
            retweeterLabel.text = tweet.retweeterHandle
        } else {
            retweeterLabel.text = ""
             retweeterImage.image = nil
        }
        
        userNameLabel.text = tweet.user?.name ?? ""
        userHandleLabel.text = "@\(tweet.user?.screenname ?? "")"
        
        if let timestamp = tweet.timestamp {
            let timeIntervalSince = fabs(timestamp.timeIntervalSinceNow)
            let formatedTimeIntervalSinceString = format(duration: timeIntervalSince)
            timestampLabel.text = formatedTimeIntervalSinceString
        }
        
        tweetContentLabel.text = tweet.text
        retweetCountLabel.text = String(tweet.retweetCount)
        favoriteCountLabel.text = String(tweet.favoritesCount)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func format(duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        return formatter.string(from: duration)!
    }

}
