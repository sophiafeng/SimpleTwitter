//
//  MenuViewController.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/21/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var mentionsVC: UIViewController!
    private var profileVC: UIViewController!
    private var tweetsVC: UIViewController!
    
    var viewControllers: [UIViewController] = []
    let menuTitles = ["Homefeed", "Profile", "Mentions"]
    var hamburgerVC: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mentionsVC = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        tweetsVC = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        viewControllers.append(tweetsVC)
        viewControllers.append(profileVC)
        viewControllers.append(mentionsVC)
        
        hamburgerVC.contentVC = tweetsVC
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
        
        let menuTitle = menuTitles[indexPath.row]
        cell.menuTitle.text = menuTitle
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.contentView.backgroundColor = UIColor(red:0.31, green:0.77, blue:1.00, alpha:1.0)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerVC.contentVC = viewControllers[indexPath.row];
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
