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
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
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
        
        replyButton.setImage(#imageLiteral(resourceName: "twitter_reply_icon"), for: UIControlState.normal)
        retweetButton.setImage(#imageLiteral(resourceName: "twitter_retweet_icon"), for: UIControlState.normal)
        favoriteButton.setImage(#imageLiteral(resourceName: "twitter_favorite_icon"), for: UIControlState.normal)
        favoriteButton.setImage(#imageLiteral(resourceName: "twitter_favorited_icon"), for: UIControlState.selected)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
