//
//  customButton.swift
//  ParkMe
//
//  Created by AC on 5/1/16.
//  Copyright © 2016 AC. All rights reserved.
//

import UIKit

class customButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        
        self.frame = CGRectMake(100, 100, 300, 40)
        self.setTitle("GET STARTED", forState: UIControlState.Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).CGColor
        self.layer.cornerRadius = cornerRadius
        
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.whiteColor().CGColor
        self.layer.shadowOpacity = 0.3
    }
}
