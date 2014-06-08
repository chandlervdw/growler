//
//  BusinessTableViewController.swift
//  Growler
//
//  Created by Chandler Van De Water on 6/8/14.
//  Copyright (c) 2014 Chandler Van De Water. All rights reserved.
//

import UIKit

class BusinessTableViewController: UITableViewController {
    
    @lazy var Business: NSArray = {
        let pathTCT = NSBundle.mainBundle().pathForResource("TCT", ofType: "json")
        let data = NSData.dataWithContentsOfFile(pathTCT, options: nil, error: nil)
        return NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "growler"))
        
        tableView.registerClass(BeerTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
//        return Business.count
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        let biz = Business[section] as NSDictionary
        let results = biz["results"] as NSDictionary
        let beers = results["collection1"] as NSArray
        return beers.count
    }
    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell = tableView!.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as BeerTableViewCell
        if let path = indexPath {
            let biz = Business[path.section] as NSDictionary
            let results = biz["results"] as NSDictionary
            let beers = results["collection1"] as NSArray
            let beer = beers[path.row] as NSDictionary
            
            cell.titleLabel.text = beer["BeerName"] as String
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        let biz = Business[section] as NSDictionary
        return biz["name"] as String
    }
    
    override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        let biz = Business[section] as NSDictionary
        let view = LocationHeaderView()
        view.titleLabel.text = (biz["name"] as String).uppercaseString
        return view
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}
