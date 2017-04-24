//
//  User.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/15/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var followerCount: Int = 0
    var tweetCount: Int = 0
    var followingCount: Int = 0
    var id: Int?
    
    var dictionary: NSDictionary?
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        followerCount = dictionary["followers_count"] as? Int ?? 0
        tweetCount = dictionary["statuses_count"] as? Int ?? 0
        followingCount = dictionary["friends_count"] as? Int ?? 0
        
        tagline = dictionary["description"] as? String
        id = dictionary["id"] as? Int ?? -1
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                
                let userData = defaults.object(forKey: "currentUserData") as? Data
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                    
                    
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else{
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
