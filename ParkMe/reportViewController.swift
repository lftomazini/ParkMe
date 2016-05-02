//
//  reportViewController.swift
//  ParkMe
//
//  Created by AC on 4/26/16.
//  Copyright © 2016 AC. All rights reserved.
//

import UIKit
import Material
import SCLAlertView

class reportViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var annotation: Annotation!
    
    private let tableHeaderCutAway: CGFloat = 50.0
    
    private let tableHeaderHeight: CGFloat = 150.0
    
    private var headerView: reportHeaderView!
    
    private var headerMaskLayer: CAShapeLayer!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        
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

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
}

extension reportViewController: UITableViewDataSource
{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Option Cell", forIndexPath: indexPath) as! CustomTableViewCell
        
//        if (indexPath.row == 1) {
//            
//            cell.textView.allowsEditingTextAttributes = true
//            
//            switch annotation.title! {
//            case "Smith":
//                let attributedStr = NSMutableAttributedString(string: "Decals: 🔵\n")
//                let attrs = [
//                    NSForegroundColorAttributeName : UIColor.blackColor(),
//                    NSFontAttributeName : UIFont(name: "ChalkboardSE-Bold", size: 22)!
//                ]
//                attributedStr.addAttributes(attrs, range: NSRange())
//                cell.textView.attributedText = attributedStr
//            default:
//                cell.textView.text = ""
//            }
//            
//            cell.textView.font = UIFont(name: "ArialMT", size: 17)!
//            cell.textView.textAlignment = .Center
//        }
        
        if (indexPath.row == 3) {
            let reportFullBtn = FlatButton(frame: CGRectMake(40, 60, 300, 40))
            reportFullBtn.backgroundColor = UIColorFromRGB(0x3AAAFE)
            let cellHeight: CGFloat = 44.0
            reportFullBtn.center = CGPoint(x: view.bounds.width / 2.0, y: cellHeight / 2.0)
            reportFullBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            reportFullBtn.addTarget(self, action: #selector(reportViewController.reportFull(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            reportFullBtn.setTitle("Report this lot is full", forState: UIControlState.Normal)
            reportFullBtn.titleLabel?.font = UIFont(name: "ArialMT", size: 20)!
            
            cell.addSubview(reportFullBtn)
        }
        
        if (indexPath.row == 5) {
            let reportIssueBtn = FlatButton(frame: CGRectMake(40, 60, 200, 40))
            reportIssueBtn.backgroundColor = UIColorFromRGB(0xFF486C)
            let cellHeight: CGFloat = 44.0
            reportIssueBtn.center = CGPoint(x: view.bounds.width / 2.0, y: cellHeight / 2.0)
            reportIssueBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            reportIssueBtn.addTarget(self, action: #selector(reportViewController.reportIssue(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            reportIssueBtn.setTitle("Report an issue", forState: UIControlState.Normal)
            reportIssueBtn.titleLabel?.font = UIFont(name: "ArialMT", size: 18)!
            
            cell.addSubview(reportIssueBtn)
        }
        
        if (indexPath.row == 1) {
            let favBtn = DOFavoriteButton(frame: CGRectMake(0, 0, 20, 20), image: UIImage(named: "favorite"))
            favBtn.imageColorOn = UIColor(red: 254/255, green: 110/255, blue: 111/255, alpha: 1.0)
            favBtn.circleColor = UIColor(red: 254/255, green: 110/255, blue: 111/255, alpha: 1.0)
            favBtn.lineColor = UIColor(red: 226/255, green: 96/255, blue: 96/255, alpha: 1.0)
            let cellHeight: CGFloat = 44.0
            favBtn.center = CGPoint(x: view.bounds.width / 2.0, y: cellHeight / 2.0)
            favBtn.addTarget(self, action: #selector(reportViewController.tapped(_:)), forControlEvents: .TouchUpInside)
            cell.addSubview(favBtn)
        }
        return cell
    }
    
    @IBAction func reportFull(sender: AnyObject) {
        
        let alertView = SCLAlertView()
        alertView.addButton("Yes") {
            SCLAlertView().showSuccess("Thank you", subTitle: "Your report has been recorded!")
        }
        alertView.addButton("No") {
            print("This user is dumb lol!")
        }
        alertView.showCloseButton = false
        alertView.showWarning("Warning", subTitle: "Are you sure you want to report this lot is full?")
        
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
        alertView.addButton("Close") {print("This user is dumb lol!")}
        alertView.showCloseButton = false
        alertView.showEdit("Report an issue", subTitle: "Please tell us what your issue is")
        
    }
    
    @IBAction func tapped(sender: DOFavoriteButton) {
        if sender.selected {
            // deselect
            sender.deselect()
        } else {
            // select with animation
            sender.select(animate: true)
        }
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
