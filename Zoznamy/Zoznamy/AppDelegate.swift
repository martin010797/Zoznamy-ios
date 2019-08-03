//
//  AppDelegate.swift
//  Zoznamy
//
//  Created by Martin Kostelej on 14/07/2019.
//  Copyright © 2019 Martin Kostelej. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //toto som ja pridaval
    //public var darkMode: Bool?


    //vola sa ked sa appka nastartuje
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        //nastavenie farby status barstyle pismen(cas, bateria...)
        application.statusBarStyle = .lightContent
        //UIViewController preferredStatusBarStyle
        
        //nastavovanie navigacneho baru
        UINavigationBar.appearance().barTintColor = UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        //nadpisy na navigacnych baroch
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)]
        //navratova sipka
        UINavigationBar.appearance().tintColor = .white
        //tlacidla na navigacnom bare
        UIBarButtonItem.appearance().tintColor = .white
        
        //spodny bar pre vyberanie obrazoviek
        UITabBar.appearance().barTintColor = UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        //aktivny prvok
        UITabBar.appearance().tintColor = .white
        
        //pozadie text fieldu pri pridavani alebo upravovani zoznamov a prvkov
        UITextField.appearance().backgroundColor = UIColor(red: 90.0/255.0, green: 90.0/255.0, blue: 90.0/255.0, alpha: 1.0)
        //farba textu v text fielde
        UITextField.appearance().textColor = .white

        //tabulky
        UITableView.appearance().backgroundColor = .black
        //medzery medzi cells v tabulke
        UITableView.appearance().separatorColor = .black
        UITableViewCell.appearance().backgroundColor = .black
        
        //popisky
        UILabel.appearance().textColor = .white
    
 
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

