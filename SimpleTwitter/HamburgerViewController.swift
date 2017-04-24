//
//  HamburgerViewController.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/21/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentLeftMarginConstraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!
    var contentVC: UIViewController! {
        didSet(oldContentVC) {
            view.layoutIfNeeded()
            
            if oldContentVC != nil {
                oldContentVC.willMove(toParentViewController: nil)
                oldContentVC.view.removeFromSuperview()
                oldContentVC.didMove(toParentViewController: nil)
            }
            
            contentVC.willMove(toParentViewController: self)
            contentView.addSubview(contentVC.view)
            contentVC.didMove(toParentViewController: self)
            closeMenu()
        }
    }
    var menuVC: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuVC.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeMenu() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.contentLeftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { (Bool) in
        })
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            originalLeftMargin = contentLeftMarginConstraint.constant
        } else if sender.state == .changed {
            contentLeftMarginConstraint.constant = originalLeftMargin + translation.x
        } else if sender.state == .ended {
            if velocity.x > 0 {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.contentLeftMarginConstraint.constant = self.view.frame.size.width - 200
                    self.view.layoutIfNeeded()
                }, completion: { (Bool) in
                })
                
            } else {
                closeMenu()
            }
        }
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
