//
//  AppDelegate.swift
//  Todoey
//
//  Created by George Hadjisavvas on 30/12/2018.
//  Copyright © 2018 George Hadjisavvas. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //printing url of realm database
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
     
        do {
            let realm = try Realm()
            
        } catch {
            print("Error initialisting new Realm \(error)")
        }
        
        
        return true
    }



    func applicationWillTerminate(_ application: UIApplication) {
       
        
    }


}

