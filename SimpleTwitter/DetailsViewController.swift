//
//  DetailsViewController.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/16/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var retweeterLabel: UILabel!
    @IBOutlet weak var retweeterImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBAction func onRetweetButton(_ sender: RetweetButton) {
        print("retweet button tapped")
        if(sender.isSelected) {
            sender.isSelected = false
            tweet?.retweeted = false
            retweetCountLabel.text = String(describing: (tweet?.retweetCount)!)
        } else {
            sender.isSelected = true
            tweet?.retweeted = true
            retweetCountLabel.text = String(describing: (tweet?.retweetCount)!)
        }
    }
    @IBAction func onFavoriteButton(_ sender: FavoriteButton) {
        print("favorite button tapped")
        if(sender.isSelected) {
            sender.isSelected = false
            tweet?.favorited = false
            favoriteCountLabel.text = String(describing: (tweet?.favoritesCount)!)
        } else {
            sender.isSelected = true
            tweet?.favorited = true
            favoriteCountLabel.text = String(describing: (tweet?.favoritesCount)!)
        }
    }
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //@(todo) put in util
        if (tweet?.retweeterHandle != nil) {
            retweeterImage.image = #imageLiteral(resourceName: "twitter_retweet_icon")
            retweeterLabel.text = tweet?.retweeterHandle
        } else {
            retweeterLabel.text = ""
            retweeterImage.image = nil
        }
        tweetContentLabel.text = tweet?.text
        if let timestamp = tweet?.timestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/dd/yy, h:mm a"
            dateFormatter.amSymbol = "am"
            dateFormatter.pmSymbol = "pm"
            timestampLabel.text = dateFormatter.string(from: timestamp)
        } else {
            timestampLabel.text = ""
        }
        
        let user = tweet?.user
        if let userImageUrl = user?.profileUrl {
            userImage.setImageWith(userImageUrl, placeholderImage: #imageLiteral(resourceName: "twitter_icon"))
            userImage.layer.cornerRadius = 5
            userImage.clipsToBounds = true
        }
        userNameLabel.text = user?.name ?? ""
        userHandleLabel.text = "@\(user?.screenname ?? "")"
        
        retweetCountLabel.text = String(describing: (tweet?.retweetCount)!)
        favoriteCountLabel.text = String(describing: (tweet?.favoritesCount)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "detailsReplyComposerSegue" {
            let navigationController = segue.destination as! UINavigationController
            let tweetComposerVC = navigationController.topViewController as! TweetComposerViewController
            tweetComposerVC.repliedTweet = tweet
        }
    }

}
