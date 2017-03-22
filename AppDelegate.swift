//
//  AppDelegate.swift
//  lang
//
//  Created by Vivian Cheng on 14/07/2016.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import ParseUI
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    var parseLoginHelper: ParseLoginHelper!
    
    override init() {
        super.init()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let _ = user {
                // if login was successful, display the TabBarController
                // 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController")
                // 3
                self.window?.rootViewController!.presentViewController(viewController, animated:true, completion:nil)
            }
        }
    }
var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Set up the Parse SDK
        let configuration = ParseClientConfiguration {
            $0.applicationId = "lang"
            $0.server = "https://lang-parse-vc.herokuapp.com/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        // Initialize Facebook
        // 1
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
        // check if we have logged in user
        // 2
        let user = PFUser.currentUser()
        
        
        let startViewController: UIViewController
        
        if (user != nil) {
            // 3
            // if we have a user, set the TabBarController to be the initial view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            startViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as! UIViewController
        } else {
            // 4
            // Otherwise set the LoginViewController to be the first
            let loginViewController = PFLogInViewController()
            //loginViewController.viewController = PFLogInViewController()
            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .Facebook]
            loginViewController.delegate = parseLoginHelper
            loginViewController.signUpController?.delegate = parseLoginHelper
            
            startViewController = loginViewController
            
    /Users/viviancheng/Downloads/Makestagram-Swift-V2-Solution-part2-solution 5/Makestagram/Base.lproj/Main.storyboard
            
            var logoImage = UIImageView()
            logoImage.image = UIImage(named: "Untitled-3")
            logoImage.contentMode = UIViewContentMode.ScaleAspectFit
            
            loginViewController.logInView?.logo = logoImage
            
            loginViewController.logInView?.backgroundColor = UIColor(patternImage: UIImage(named: "ase")!)

        }
        
        // 5
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = startViewController;
        self.window?.makeKeyAndVisible()
               return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)    }
    
    
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
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    
    }
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

