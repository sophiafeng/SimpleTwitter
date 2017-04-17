//
//  TwitterClient.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/15/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "6GtdlsXT8sVDGLkk2rdDAS1yU", consumerSecret: "QOmmxpTtYnzakPejHftQAVc5ykqg9NcD2m66EAPh7JsXAmBpUD")

    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
    
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "simpletwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("got my request token")
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }) { (error: Error!) -> Void in
            print("error: \(String(describing: error?.localizedDescription))")
            self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            print("got my access token")
            
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) -> () in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            print("error: \(String(describing: error?.localizedDescription))")
            self.loginFailure?(error)
        })

    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
        
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: {
            (task: URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func homeTimeline(lastTweetId: Int? = nil, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        var params = ["count": 20]
        if lastTweetId != nil {
            params["max_id"] = lastTweetId
        }
        get("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: {
            (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func newTweet(tweetText: String, replyToTweetId: NSNumber? = 0, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
            post("/1.1/statuses/update.json", parameters: ["status": tweetText, "in_reply_to_status_id": Int(replyToTweetId ?? 0)], progress: nil, success: { (_: URLSessionDataTask, resp) -> Void in
                let tweet = Tweet(dictionary: resp as! NSDictionary)
                success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
            })
    }
    
    func retweet(params: NSDictionary?, retweet: Bool, completion: @escaping (Tweet?, Error?) -> (Void)) {
        let tweetID = params!["id"] as! Int
        let endpoint = retweet ? "retweet" : "unretweet"
        post("1.1/statuses/\(endpoint)/\(tweetID).json", parameters: params, progress: nil, success: { (_: URLSessionDataTask, resp) -> Void in
            let tweet = Tweet(dictionary: resp as! NSDictionary)
            completion(tweet, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            completion(nil, error)
        })
    }
    
    func favorite(params: NSDictionary?, favorite: Bool, completion: @escaping (Tweet?, Error?) -> (Void)) {
        let endpoint = favorite ? "create" : "destroy"
        post("1.1/favorites/\(endpoint).json", parameters: params, progress: nil, success: { (_: URLSessionDataTask, resp) -> Void in
            let tweet = Tweet(dictionary: resp as! NSDictionary)
            completion(tweet, nil)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            completion(nil, error)
        })
    }
}
