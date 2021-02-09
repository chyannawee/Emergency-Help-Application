//
//  AppDelegate.swift
//  War
//
//  Created by Chyanna Wee on 25/04/2018.
//  Copyright © 2018 Chyanna Wee. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import AVFoundation
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MFMessageComposeViewControllerDelegate, AVAudioPlayerDelegate {

    var window: UIWindow?
    //var sirenSoundEffect: AVAudioPlayer?
    var player: AVAudioPlayer?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MakeSchoolNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //3D touch
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {

        if shortcutItem.type == "com.chyannawee.War.call"
        {
            print ("call tapped")
                let url: NSURL = URL (string: "TEL:" + ListContactsTableViewController.GlobalVariable.setNumber)! as NSURL
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)

        }
        else if shortcutItem.type == "com.chyannawee.War.message"
        {
            print(ListContactsTableViewController.GlobalVariable.setNumber)

            if MFMessageComposeViewController.canSendText() {
                let controller = MFMessageComposeViewController()
                controller.body = ListContactsTableViewController.GlobalVariable.setMessage 
                controller.recipients = [ListContactsTableViewController.GlobalVariable.setNumber]
                controller.messageComposeDelegate = self
                self.window?.rootViewController?.present(controller, animated: true, completion: nil)
            }else{
                print ("Cannot send text")
            }
        }
        else if shortcutItem.type == "com.chyannawee.War.record"
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let targetVC = storyboard.instantiateViewController(withIdentifier :"RecorderViewController") as! RecorderViewController
            if let navC = window?.rootViewController as! UINavigationController? {
                navC.pushViewController(targetVC, animated: false)
            } 
        }
        else if shortcutItem.type == "com.chyannawee.War.sound"{
            guard let url = Bundle.main.url(forResource: "siren", withExtension: "mp3") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let player = player else { return }

                player.play()
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.window?.rootViewController?.dismiss (animated: true, completion: nil)
    }

}

