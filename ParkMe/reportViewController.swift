//
//  reportViewController.swift
//  ParkMe
//
//  Created by AC on 4/26/16.
//  Copyright © 2016 AC. All rights reserved.
//

import UIKit

class reportViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var annotation: Annotation!
    
    private let tableHeaderCutAway: CGFloat = 50.0
    
    private let tableHeaderHeight: CGFloat = 150.0
    
    private var headerView: reportHeaderView!
    
    private var headerMaskLayer: CAShapeLayer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView = tableView.tableHeaderView as! reportHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.blackColor().CGColor
        headerView.layer.mask = headerMaskLayer
        
        updateUI()

        // Do any additional setup after loading the view.
        updateHeaderView()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
    }

    func updateHeaderView() {
        let effectiveHeight = tableHeaderHeight - tableHeaderCutAway / 2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + tableHeaderCutAway/2
        }
        
        headerView.frame = headerRect
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 0, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: 0))
        path.addLineToPoint(CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height))
        headerMaskLayer?.path = path.CGPath
        
    }
    
    func updateUI() {
        
        headerView.lotNameLabel.text = annotation.title!
        headerView.backgroundImageView.image = UIImage(named: annotation.imageName!)
        
    }

}

extension reportViewController: UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Option Cell", forIndexPath: indexPath) as UITableViewCell
        
        if (indexPath.row == 2 ) {
            let reportFullBtn : UIButton = UIButton(type: UIButtonType.Custom) as UIButton
            reportFullBtn.frame = CGRectMake(40, 60, 250, 30)
            let cellHeight: CGFloat = 44.0
            reportFullBtn.center = CGPoint(x: view.bounds.width / 2.0, y: cellHeight / 2.0)
            reportFullBtn.setTitleColor(UIColorFromRGB(0x0D94FC), forState: UIControlState.Normal)
            reportFullBtn.addTarget(self, action: #selector(reportViewController.reportFull(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            reportFullBtn.setTitle("Report this lot is full", forState: UIControlState.Normal)
            reportFullBtn.titleLabel?.font = UIFont(name: "ArialMT", size: 16)!
            
            cell.addSubview(reportFullBtn)
        }
        
        if (indexPath.row == 3) {
            let reportIssueBtn : UIButton = UIButton(type: UIButtonType.Custom) as UIButton
            reportIssueBtn.frame = CGRectMake(40, 60, 250, 30)
            let cellHeight: CGFloat = 44.0
            reportIssueBtn.center = CGPoint(x: view.bounds.width / 2.0, y: cellHeight / 2.0)
            reportIssueBtn.setTitleColor(UIColorFromRGB(0x0D94FC), forState: UIControlState.Normal)
            reportIssueBtn.addTarget(self, action: #selector(reportViewController.reportIssue(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            reportIssueBtn.setTitle("Report an issue", forState: UIControlState.Normal)
            reportIssueBtn.titleLabel?.font = UIFont(name: "ArialMT", size: 16)!
            
            cell.addSubview(reportIssueBtn)
        }
        return cell
    }
    
    @IBAction func reportFull(sender: AnyObject) {
        
        let alertView = SCLAlertView()
        alertView.addButton("Yes") {
            SCLAlertView().showSuccess("Thank you", subTitle: "Your report has been recorded!")
        }
        alertView.addButton("No") {
            
        }
        alertView.showCloseButton = false
        alertView.showWarning("Waring", subTitle: "Are you sure you want to report this lot is full?")
        
    }
    
    @IBAction func reportIssue(sender: AnyObject) {
        
        let alertView = SCLAlertView()
        let issue = alertView.addTextField("Please enter your issue")
        
        alertView.addButton("Submit") {
            if ( issue.text != "" ) {
                SCLAlertView().showSuccess("Thank you", subTitle: "Your issue has been sent to us and we will work on it.")
            } else {
                SCLAlertView().showError("Error", subTitle: "No issue entered!")
            }
        }
        alertView.showEdit("Report an issue", subTitle: "Please tell us what your issue is")
        
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension reportViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        updateHeaderView()
    }
}
