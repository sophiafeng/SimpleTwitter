//
//  LoginViewController.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/14/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBAction func onLoginButton(_ sender: UIButton) {
        TwitterClient.sharedInstance?.login(success: {
            print("I'm logged in")
            self.performSegue(withIdentifier: "userLoginSegue", sender: nil)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let hamburgerVC = segue.destination as! HamburgerViewController
        menuVC.hamburgerVC = hamburgerVC
        hamburgerVC.menuVC = menuVC
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
