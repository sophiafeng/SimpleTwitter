//
//  TweetCell.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/15/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweeterImage: UIImageView!
    
    func buildCellWithTweet(tweet: Tweet) {
        if let userImageUrlString = tweet.userProfileImageUrlString {
            let userImageUrl = URL(string:userImageUrlString)
            userImage.setImageWith(userImageUrl!, placeholderImage: #imageLiteral(resourceName: "twitter_icon"))
            userImage.layer.cornerRadius = 5
            userImage.clipsToBounds = true
        }
        
        if (tweet.retweeterHandle != nil) {
            retweeterImage.image = #imageLiteral(resourceName: "twitter_retweet_icon")
            retweeterLabel.text = tweet.retweeterHandle
        } else {
            retweeterLabel.text = ""
             retweeterImage.image = nil
        }
        
        userNameLabel.text = tweet.userName ?? ""
        userHandleLabel.text = "@\(tweet.userHandle ?? "")"
        
        if let timestamp = tweet.timestamp {
            let timeIntervalSince = fabs(timestamp.timeIntervalSinceNow)
            let formatedTimeIntervalSinceString = format(duration: timeIntervalSince)
            timestampLabel.text = formatedTimeIntervalSinceString
        }
        
        tweetContentLabel.text = tweet.text
        replyButton.setImage(#imageLiteral(resourceName: "twitter_reply_icon"), for: UIControlState.normal)
        retweetButton.setImage(#imageLiteral(resourceName: "twitter_retweet_icon"), for: UIControlState.normal)
        favoriteButton.setImage(#imageLiteral(resourceName: "twitter_favorite_icon"), for: UIControlState.normal)
        
        
        
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
