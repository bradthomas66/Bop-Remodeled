//
//  Bop_RemodeledApp.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-12.
//
//  https://www.raywenderlich.com/11395893-push-notifications-tutorial-getting-started
//  https://www.raywenderlich.com/8277640-push-notifications-tutorial-for-ios-rich-push-notifications
//  https://developer.apple.com/documentation/usernotifications/registering_your_app_with_apns
//  https://stackoverflow.com/questions/14872088/get-push-notification-while-app-in-foreground-ios

import SwiftUI
import Firebase
import UserNotifications

@main
struct Bop_RemodeledApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistenceController = PersistenceController.shared
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authenticationHandler.sessionState != nil {
                    DashboardView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(SessionHandler())
                } else {
                    LaunchView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(SessionHandler())
                }
            }.onAppear(perform: {
                authenticationHandler.listenForAuthState()
            })
        }
    }
    

}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        return true
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.banner, .badge, .sound])
    }
     
    //take received deviceToken and convert it to a String
    //Register for notification is done in completion block of sign in/sign up so this will always have a session state
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in
            String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        sendTokenToServer(token: token)
    }
    
    func sendTokenToServer(token: String) {
        let currentUserId = Auth.auth().currentUser?.uid
        DispatchQueue.global(qos: .userInitiated).async {
            userInformationDatabaseRoot.queryOrdered(byChild: "authId")
                .queryEqual(toValue: currentUserId)
                .observeSingleEvent(of: .value, with: { snapshot in
                    if let user = snapshot.value as? NSDictionary {
                        let currentUserUsername = user.allKeys[0] as! String
                        APNsDatabaseRoot.child(currentUserUsername).updateChildValues(["token": token]) // there may be multiple. Update this
                        print("Device Token: \(token)")
                    }
                })
        }
    }
    
    //Handle errors if registerForRemoteNotifications fails
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register \(error)")
    }
    
    //app is not running and push notification was received
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self

        let notificationOptions = launchOptions?[.remoteNotification]

        if let notification = notificationOptions as? [String: AnyObject], let aps = notification["aps"] as? [String: AnyObject] {
            print(aps)
            print ("app was not running. It was launched from notification.  We would do something here")
        }
        return true
    }

    //app is running and push notification is received
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
      guard let _ = userInfo["aps"] as? [String: AnyObject] else {
          completionHandler(.failed)
          print("failed :(")
          return
      }
      print("succeeded")
    }
}

