//
//  AppDelegate.swift
//  Growler
//
//  Created by Chandler Van De Water on 6/8/14.
//  Copyright (c) 2014 Chandler Van De Water. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @lazy var window: UIWindow = {
        let win = UIWindow(frame: UIScreen.mainScreen().bounds)
        win.backgroundColor = UIColor.whiteColor()
        win.rootViewController = UINavigationController(rootViewController: BusinessTableViewController())
        return win
        }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        window.makeKeyAndVisible()
        return true
    }
}

