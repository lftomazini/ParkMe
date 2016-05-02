//
//  tutorialScreenViewController.swift
//  ParkMe
//
//  Created by AC on 5/2/16.
//  Copyright © 2016 AC. All rights reserved.
//

import UIKit

class tutorialScreenViewController: UIViewController {

    var interactor:Interactor? = nil
    
    var needTutorial:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().statusBarHidden = true
        if needTutorial {
            self.presentAnnotation()
        }
        
        
        
    }
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translationInView(view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .Began:
            interactor.hasStarted = true
            dismissViewControllerAnimated(true, completion: nil)
        case .Changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.updateInteractiveTransition(progress)
        case .Cancelled:
            interactor.hasStarted = false
            interactor.cancelInteractiveTransition()
        case .Ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finishInteractiveTransition()
                : interactor.cancelInteractiveTransition()
        default:
            break
        }
        
    }
    
    func presentAnnotation() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("gecco") as! AnnotationViewController
        viewController.alpha = 0.5
        self.presentViewController(viewController, animated: true) {
            ()->() in
            self.needTutorial = false
            
        }
        
    }

}
