//
//  TweetsViewController.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/15/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetComposerViewControllerDelegate, UIScrollViewDelegate {
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var tweets: [Tweet]! {
        didSet {
            if ((tweets?.count) != nil) && (tweets?.count)! > 0 {
                lastTweetId = tweets![tweets!.endIndex - 1].tweetId as? Int
            }
        }
    }
    
    var refreshControl: UIRefreshControl!
    var isMoreDataLoading = false
    var lastTweetId: Int? = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tableview defaults
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        loadTimelineTweets()
    }
    
    // Save list of home timeline tweets fetched from api and reload table view
    func loadTimelineTweets(loadLastTweetId: Int? = nil) {
        TwitterClient.sharedInstance?.homeTimeline(lastTweetId: loadLastTweetId, success: { (tweets: [Tweet]) in
            if self.isMoreDataLoading {
                self.tweets.append(contentsOf: tweets)
                self.isMoreDataLoading = false
            } else {
                self.tweets = tweets
            }
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: - TweetComposerViewControllerDelegate methods
    func tweetComposerViewControllerOnTweetCompletion(tweetComposerVC: TweetComposerViewController) {
        loadTimelineTweets()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "composerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let tweetComposerVC = navigationController.topViewController as! TweetComposerViewController
            tweetComposerVC.tweetComposerVCDelegte = self
        } else if segue.identifier == "detailSegue" {
            let detailsViewController = segue.destination as! DetailsViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            detailsViewController.tweet = tweets[indexPath!.row]
        } else if segue.identifier == "replyComposerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let tweetComposerVC = navigationController.topViewController as! TweetComposerViewController
            let cell = (sender as! ReplyButton).superview?.superview
            let indexPath = tableView.indexPath(for: cell as! UITableViewCell)
            tweetComposerVC.tweetComposerVCDelegte = self
            tweetComposerVC.repliedTweet = tweets[indexPath!.row]
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                loadTimelineTweets(loadLastTweetId: lastTweetId)
            }
            
        }
    }

}
