//
//  Tweet.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/15/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var retweeterHandle: String?
    var user: User?
    var tweetId: NSNumber?
    
    var favorited: Bool {
        didSet {
            if favorited {
                favoritesCount += 1
                TwitterClient.sharedInstance?.favorite(params: ["id": tweetId!], favorite: true, completion: { (tweet: Tweet?, error: Error?) -> (Void) in
                    print("favorited")
                })
            } else {
                favoritesCount -= 1
                TwitterClient.sharedInstance?.favorite(params: ["id": tweetId!], favorite: true, completion: { (tweet: Tweet?, error: Error?) -> (Void) in
                    print("unfavorited")
                })
            }
        }
    }
    var retweeted: Bool {
        didSet {
            if retweeted {
                retweetCount += 1
                TwitterClient.sharedInstance?.retweet(params: ["id": tweetId!], retweet: true, completion: { (tweet: Tweet?, error: Error?) -> (Void) in
                    print("retweeted")
                })
            } else {
                retweetCount -= 1
                TwitterClient.sharedInstance?.retweet(params: ["id": tweetId!], retweet: false, completion: { (tweet: Tweet?, error: Error?) -> (Void) in
                    print("unretweeted")
                })
            }
        }
    }
    
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = dateFormatter.date(from: timestampString)
        }
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        user = User.init(dictionary: (dictionary["user"] as? NSDictionary)!)
    
        let retweetStatusDict = dictionary["retweeted_status"] as? NSDictionary
        retweeterHandle = (retweetStatusDict?["user"] as? NSDictionary)?["screen_name"] as? String
        
        tweetId = dictionary["id"] as? NSNumber
        
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        favorited = (dictionary["favorited"] as? Bool) ?? false
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
