//
//  AppDelegate.swift
//  dz-03
//
//  Created by Jelena Šarić on 11/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if UserDefaults.standard.string(forKey: "token") != nil {
            window?.rootViewController = TabBarViewController()
        } else {
            window?.rootViewController = LoginViewController()
        }
        
        window?.makeKeyAndVisible()
        return true
    }
}

