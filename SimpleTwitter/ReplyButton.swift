//
//  ReplyButton.swift
//  SimpleTwitter
//
//  Created by Sophia on 4/16/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class ReplyButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setImage(#imageLiteral(resourceName: "twitter_reply_icon"), for: UIControlState.normal)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
