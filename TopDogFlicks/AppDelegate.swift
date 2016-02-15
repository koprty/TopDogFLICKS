//
//  AppDelegate.swift
//  TopDogFlicks
//
//  Created by Lise Ho on 1/31/16.
//  Copyright © 2016 Lise Ho. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //programmatically set up tabs
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name:"Main",bundle: nil)
        
        //NOW PLAYING Option
        let nowPlayingNavController = storyboard.instantiateViewControllerWithIdentifier("MoviesNav") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavController.topViewController as! MovieViewController
        nowPlayingViewController.endpoint="now_playing"
        nowPlayingNavController.tabBarItem.title = "Now Playing"
        nowPlayingNavController.tabBarItem.image = UIImage(named:"now_playing")
        
        //TOP RATED Option
        let topRatedNavController = storyboard.instantiateViewControllerWithIdentifier("MoviesNav") as! UINavigationController
        let topRatedViewController = topRatedNavController.topViewController as! MovieViewController
        topRatedViewController.endpoint="top_rated"
        topRatedNavController.tabBarItem.title = "Top Rated"
        topRatedNavController.tabBarItem.image = UIImage(named:"top_rated")
        
        //EXTRA FUN STUFF :D 
        //POPULAR Now
        let popularNavController = storyboard.instantiateViewControllerWithIdentifier("MoviesNav")as! UINavigationController
        let popularViewController = popularNavController.topViewController as! MovieViewController
        popularViewController.endpoint = "popular"
        popularNavController.tabBarItem.title = "Popular"
        popularNavController.tabBarItem.image = UIImage(named:"popular")
        
        
        //UPCOMING
        let upcomingNavController = storyboard.instantiateViewControllerWithIdentifier("MoviesNav") as! UINavigationController
        let upcomingViewController = upcomingNavController.topViewController as! MovieViewController
        upcomingViewController.endpoint = "upcoming"
        upcomingNavController.tabBarItem.title = "Upcoming"
        upcomingNavController.tabBarItem.image = UIImage(named:"upcoming")
        
        //insert the navigation controllers into the tabbar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavController, topRatedNavController,popularNavController,upcomingNavController]
        
        //make the tabBarController control the current window and make it visible
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        
        
        return true
    }
    


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

