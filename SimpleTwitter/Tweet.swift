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
