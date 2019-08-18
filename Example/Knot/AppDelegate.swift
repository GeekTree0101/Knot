//
//  AppDelegate.swift
//  Knot
//
//  Created by Geektree0101 on 08/16/2019.
//  Copyright (c) 2019 Geektree0101. All rights reserved.
//

import UIKit
import AsyncDisplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    if let window = window {
      window.rootViewController = ASNavigationController.init(rootViewController: ViewController.init())
      window.makeKeyAndVisible()
    }
    
    return true
  }
}

