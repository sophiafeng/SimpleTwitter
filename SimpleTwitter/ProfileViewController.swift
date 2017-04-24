//
//  ProfileViewController.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/20/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetComposerViewControllerDelegate, UIScrollViewDelegate {

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
    
    var user: User!
    
    private var tweets: [Tweet]! {
        didSet {
            if ((tweets?.count) != nil) && (tweets?.count)! > 0 {
                lastTweetId = tweets![tweets!.endIndex - 1].tweetId as? Int
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 70
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)
        
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
            self.refreshControl.endRefreshing()
            self.tweetsTableView.reloadData()
        }, failure: { (error: Error) in
            if self.isMoreDataLoading {
                self.isMoreDataLoading = false
            }
            print(error.localizedDescription)
        })
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadTimelineTweets()
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
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetsTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tweetsTableView.isDragging) {
                isMoreDataLoading = true
                loadTimelineTweets(loadLastTweetId: lastTweetId)
            }
            
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToComposerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let tweetComposerVC = navigationController.topViewController as! TweetComposerViewController
            tweetComposerVC.tweetComposerVCDelegte = self
        } else if segue.identifier == "profileToDetailsSegue" {
            let detailsViewController = segue.destination as! DetailsViewController
            let indexPath = tweetsTableView.indexPath(for: sender as! UITableViewCell)
            detailsViewController.tweet = tweets[indexPath!.row]
        } else if segue.identifier == "profileToReplyComposerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let tweetComposerVC = navigationController.topViewController as! TweetComposerViewController
            let cell = (sender as! ReplyButton).superview?.superview
            let indexPath = tweetsTableView.indexPath(for: cell as! UITableViewCell)
            tweetComposerVC.tweetComposerVCDelegte = self
            tweetComposerVC.repliedTweet = tweets[indexPath!.row]
        }
    }
    
    // MARK: - TweetComposerViewControllerDelegate methods
    func tweetComposerViewControllerOnTweetCompletion(tweetComposerVC: TweetComposerViewController) {
        loadTimelineTweets()
    }
    
}
