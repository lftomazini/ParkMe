//
//  AnnotationViewController.swift
//  ParkMe
//
//  Created by AC on 5/2/16.
//  Copyright © 2016 AC. All rights reserved.
//

import UIKit
import Gecco

class AnnotationViewController: SpotlightViewController {
    
    var stepIndex: Int = 0
    
    @IBOutlet var annotationViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func next(labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        switch stepIndex {
        case 0:
            spotlightView.appear(Spotlight.RoundedRect(center: CGPointMake(screenSize.width / 2, 68), size: CGSizeMake(screenSize.width, 40), cornerRadius: 6), duration: 0.5)
        case 1:
            spotlightView.move(Spotlight.Oval(center: CGPointMake(screenSize.width / 2 - 3, 390), diameter: 40))
        case 2:
            spotlightView.move(Spotlight.Oval(center: CGPointMake(screenSize.width - 22, screenSize.height - 22), diameter: 35))
        case 3:
            spotlightView.move(Spotlight.RoundedRect(center: CGPointMake(screenSize.width / 2, 22), size: CGSizeMake(screenSize.width, 40), cornerRadius: 6), moveType: .Disappear)
        case 4:
            dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
        
    }
    
    func updateAnnotationView(animated: Bool) {
        annotationViews.enumerate().forEach { index, view in
            UIView .animateWithDuration(animated ? 0.25 : 0) {
                view.alpha = index == self.stepIndex ? 1 : 0
            }
        }
    }
}

extension AnnotationViewController: SpotlightViewControllerDelegate {
    func spotlightViewControllerWillPresent(viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerTapped(viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }
    
    func spotlightViewControllerWillDismiss(viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}
