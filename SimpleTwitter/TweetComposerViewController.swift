//
//  TweetComposerViewController.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/16/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

@objc protocol TweetComposerViewControllerDelegate {
    @objc optional func tweetComposerViewControllerOnTweetCompletion(tweetComposerVC: TweetComposerViewController)
}

class TweetComposerViewController: UIViewController {
    weak var tweetComposerVCDelegte: TweetComposerViewControllerDelegate?
    var repliedTweet: Tweet?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTweet(_ sender: UIBarButtonItem) {
        // No need to call API if tweet text field is empty
        if tweetTextField.text != nil && (tweetTextField.text?.trimmingCharacters(in: .whitespaces).characters.count)! > 0 {
            TwitterClient.sharedInstance?.newTweet(tweetText: tweetTextField.text!, replyToTweetId: repliedTweet?.tweetId, success: {_ in
                print("retweeted")
                self.dismiss(animated: true) {
                    self.tweetComposerVCDelegte?.tweetComposerViewControllerOnTweetCompletion?(tweetComposerVC: self)
                }
            }, failure: { (error: Error) in
                print("Error: \(error.localizedDescription)")
            })
        } else {
            showErrorAlert(title: "Invalid tweet", errorMsg: "Tweet content cannot be empty")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User.currentUser
        
        userNameLabel.text = user?.name
        
        // @(todo) put this in utility
        if let userImageUrl = user?.profileUrl {
            userImage.setImageWith(userImageUrl, placeholderImage: #imageLiteral(resourceName: "twitter_icon"))
            userImage.layer.cornerRadius = 5
            userImage.clipsToBounds = true
        }
        
        userHandleLabel.text = "@\(user?.screenname ?? "")"

        if let usernameReplyingTo = repliedTweet?.user?.screenname {
            tweetTextField.text = "@\(usernameReplyingTo): "
        }
        
        tweetTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showErrorAlert(title: String, errorMsg: String) {
        let alertController = UIAlertController(title: title, message: errorMsg, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
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
