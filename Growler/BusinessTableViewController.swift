//
//  BusinessTableViewController.swift
//  Growler
//
//  Created by Chandler Van De Water on 6/8/14.
//  Copyright (c) 2014 Chandler Van De Water. All rights reserved.
//

import UIKit

class BusinessTableViewController: UITableViewController {
    
    var data: NSMutableData = NSMutableData()
    var Business: NSMutableArray = NSMutableArray()
    let nameGBX = "Greenville Beer Exchange"
    let nameTCT = "Community Tap"
    let nameGST = "Growler Station"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "growler"))
        
        tableView.registerClass(BeerTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        
        fetchKimono()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return Business.count
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        if (Business.count > 0) {
            let biz = Business[section] as NSDictionary
            let beers = biz["results"] as NSArray
            return beers.count
        } else {
            return 0;
        }
    }
    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell = tableView!.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as BeerTableViewCell
        if let path = indexPath {
            let biz = Business[path.section] as NSDictionary
            let beers = biz["results"] as NSArray
            let beer = beers[path.row] as NSDictionary
            
            cell.titleLabel.text = beer["BeerName"] as String
        } else {
            cell.titleLabel.text = "Loading"
        }
        
        return cell
    }

    override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        let view = LocationHeaderView()
        let biz = Business[section] as NSDictionary
        if (Business.count > 0) {
            let count = "\(Business.count)"
            view.titleLabel.text = (biz["name"] as String).uppercaseString
        }
        return view
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func fetchKimono() {
        var urlPath = "http://www.kimonolabs.com/api/26m4jq24?apikey=562e9e01b62e204058a2be0c50b12b68"
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        connection.start()
    }
    
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        // Recieved a new request, clear out the data object
        self.data = NSMutableData()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        // Append the recieved chunk of data to our data object
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        // Request complete, self.data should now hold the resulting info
        // Convert the retrieved data in to an object through JSON deserialization
        var err: NSError
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        var results: NSDictionary = jsonResult["results"] as NSDictionary
        var collection: NSArray = results["collection1"] as NSArray
        if jsonResult.count>0 && collection.count>0 {
            
            var GBX = NSMutableDictionary()
                GBX["name"] = nameGBX
                GBX["results"] = NSMutableArray()
            var TCT = NSMutableDictionary()
                TCT["name"] = nameTCT
                TCT["results"] = NSMutableArray()
            var GST = NSMutableDictionary()
                GST["name"] = nameGST
                GST["results"] = NSMutableArray()
            
            for d : AnyObject in collection {
                switch d["api"] as String {
                    case nameGBX: GBX["results"].addObject(d)
                    case nameTCT: TCT["results"].addObject(d)
                    case nameGST: GST["results"].addObject(d)
                    default: return
                }
            }
            Business.addObject(TCT)
            Business.addObject(GBX)
            Business.addObject(GST)
            tableView.reloadData()
        }
    }
}
