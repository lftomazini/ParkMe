//
//  customPageViewController.swift
//  ParkMe
//
//  Created by AC on 4/30/16.
//  Copyright © 2016 AC. All rights reserved.
//

import UIKit
import BWWalkthrough

class customPageViewController: BWWalkthroughPageViewController {
    
    @IBOutlet var backgroundView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.zPosition = -1000
        view.layer.doubleSided = false
        self.backgroundView.layer.masksToBounds = false
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func walkthroughDidScroll(position: CGFloat, offset: CGFloat) {
        var tr = CATransform3DIdentity
        tr.m34 = -1/1000.0
        view.layer.transform = CATransform3DRotate(tr, CGFloat(M_PI)  * (1.0 - offset), 0.5,1, 0.2)
    }
}
