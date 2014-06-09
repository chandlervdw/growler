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
    
    @lazy var Business: NSDictionary = {
        let pathTCT = NSBundle.mainBundle().pathForResource("TCT", ofType: "json")
        let data = NSData.dataWithContentsOfFile(pathTCT, options: nil, error: nil)
        return NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "growler"))
        
        tableView.registerClass(BeerTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .None
        
        fetchKimono()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
//        return Business.count
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        let results: NSDictionary = Business["results"] as NSDictionary
        let beers: NSArray = results["collection1"] as NSArray
        return beers.count
    }
    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell = tableView!.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath!) as BeerTableViewCell
        if let path = indexPath {
            let results = Business["results"] as NSDictionary
            let beers = results["collection1"] as NSArray
            let beer = beers[path.row] as NSDictionary
            
            cell.titleLabel.text = beer["BeerName"] as String
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return Business["name"] as String
    }
    
    override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
        let view = LocationHeaderView()
        view.titleLabel.text = (Business["name"] as String).uppercaseString
        return view
    }
    
    override func tableView(tableView: UITableView!, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func fetchKimono() {
//        var urlPath = "http://www.kimonolabs.com/api/dt5auhf6?apikey=562e9e01b62e204058a2be0c50b12b68"
        
//        var urlPath = "http://www.kimonolabs.com/api/9hyu7lv6?apikey=562e9e01b62e204058a2be0c50b12b68"
        // Growler Station
        var urlPath = "http://www.kimonolabs.com/api/8qtnxwk4?apikey=562e9e01b62e204058a2be0c50b12b68"
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
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options:    NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        var results: NSDictionary = jsonResult["results"] as NSDictionary
        var collection: NSArray = results["collection1"] as NSArray
        if jsonResult.count>0 && collection.count>0 {
            Business = jsonResult
            tableView.reloadData()
        }
    }
}
