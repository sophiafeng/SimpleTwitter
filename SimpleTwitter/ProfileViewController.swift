//
//  ProfileViewController.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/20/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userTweetCount: UILabel!
    @IBOutlet weak var userFollowerCount: UILabel!
    @IBOutlet weak var userFollowingCount: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var tweetsTableView: UITableView!
    @IBOutlet weak var taglineLabel: UILabel!
    
    var refreshControl: UIRefreshControl!
    var isMoreDataLoading = false
    var lastTweetId: Int? = -1
    var userId: Int? = -1
    
    private var tweets: [Tweet]! {
        didSet {
            if ((tweets?.count) != nil) && (tweets?.count)! > 0 {
                lastTweetId = tweets![tweets!.endIndex - 1].tweetId as? Int
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 70
        
        let user = User.currentUser
        
        userName.text = user?.name
        userHandle.text = "@\(user?.screenname ?? "")"
        
        if let userImageUrl = user?.profileUrl {
            userImage.setImageWith(userImageUrl, placeholderImage: #imageLiteral(resourceName: "twitter_icon"))
            userImage.layer.cornerRadius = 5
            userImage.clipsToBounds = true
        }

        TwitterClient.sharedInstance?.profileBanner(userHandle: user?.screenname, completion: { (urlString: String?, error: Error?) -> (Void) in
            if let urlString = urlString {
                let url = URL(string: urlString)
                self.coverImage.setImageWith(url!, placeholderImage: #imageLiteral(resourceName: "twitter_icon"))
                self.coverImage.layer.cornerRadius = 5
                self.coverImage.clipsToBounds = true
            }
        })
        
        userFollowerCount.text = String(describing: user?.followerCount ?? 0)
        userFollowingCount.text = String(describing: user?.followingCount ?? 0)
        userTweetCount.text = String(describing: user?.tweetCount ?? 0)
        
        taglineLabel.text = user?.tagline
        
        userId = user?.id
        
        loadTimelineTweets()
    }
    
    // Save list of home timeline tweets fetched from api and reload table view
    func loadTimelineTweets(loadLastTweetId: Int? = nil) {
        TwitterClient.sharedInstance?.userTimeline(userId: userId, lastTweetId: loadLastTweetId, success: { (tweets: [Tweet]) in
            if self.isMoreDataLoading {
                self.tweets.append(contentsOf: tweets)
                self.isMoreDataLoading = false
            } else {
                self.tweets = tweets
            }
            self.tweetsTableView.reloadData()
        }, failure: { (error: Error) in
            if self.isMoreDataLoading {
                self.isMoreDataLoading = false
            }
            print(error.localizedDescription)
        })
    }
    
    // MARK: - UITableViewDataSource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        
        let tweet = tweets[indexPath.row]
        cell.buildCellWithTweet(tweet: tweet)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
}
