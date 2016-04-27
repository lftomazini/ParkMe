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
        path.addLineToPoint(CGPoint(x: 0, y: headerRect.height - tableHeaderCutAway))
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
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Option Cell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }
}

extension reportViewController: UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        updateHeaderView()
    }
}
