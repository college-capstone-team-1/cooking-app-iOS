//
//  AppDelegate.swift
//  EcoRecipe
//
//  Created by 미미밍 on 2022/10/05.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import UserNotifications
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public static var user: GIDGoogleUser!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        //구글로그인 상태 복원
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
          if error != nil || user == nil {
            print("구글 로그아웃 상태")
          } else {
            print("구글 로그인 상태")
          }
        }

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         Messaging.messaging().apnsToken = deviceToken
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
            */
        let container = NSPersistentContainer(name: "Model")
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
    
    func application(
        _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        var handled: Bool

        handled = GIDSignIn.sharedInstance.handle(url)

        if handled {
            return true
        }
        return false
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 포그라운드에서 푸시메시지 수신될 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("\(#function)")
        print("UserInfo: \(notification.request.content.userInfo)")
        completionHandler([.list, .banner, .sound, .badge])
    }

    // 푸시메시지를 눌렀을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("\(#function)")
        print("UserInfo: \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {return}
        print("파이어베이스 registration token: \(fcmToken)")
    }
}
