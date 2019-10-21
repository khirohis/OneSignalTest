//
//  AppDelegate.swift
//  OneSignalTest
//
//  Created by Hirohisa Kobayasi on 2019/10/18.
//  Copyright © 2019 Hirohisa Kobayasi. All rights reserved.
//

import UIKit

import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // For debugging
//        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)

        let appId = "OneSignal APP_ID"
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            self.onNotificationReceived(notification)
        }
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            self.onNotificationOpened(result)
        }
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: appId,
                                        handleNotificationReceived: notificationReceivedBlock,
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
            })

        window = UIWindow(frame: UIScreen.main.bounds)
        if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController() {
            let navigationVc = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = navigationVc
        }

        return true
    }

    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                // authorized
                print("Notification authorized.")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                // denied
                print("Notification denied.")
            }
        }
    }

    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            // subscribed
            print("Notification subscribed.")
        }
    }

    func onNotificationReceived(_ notification: OSNotification?) -> Void {
        print("Received Notification: \(notification!.payload.notificationID ?? "N/A")")
    }

    func onNotificationOpened(_ result: OSNotificationOpenedResult?) -> Void {
        print("Opened Notification: \(result!.notification!.payload.notificationID ?? "N/A")")

        if let additionalData = result!.notification.payload!.additionalData {
            if let event = additionalData["event"] as? String {
                switch event {
                    
                case "talk":
                    onTalkEvent(additionalData)

                case "chat":
                    onChatEvent(additionalData)

                case "news":
                    onNewsEvent(additionalData)

                default:
                    print("Unknown event: \(event)");
                }
            }
        }
    }

    func onTalkEvent(_ additionalData: [AnyHashable: Any]) -> Void {
        let id = additionalData["id"] as? String
        let group_id = additionalData["group_id"] as? String
        let joined_at = additionalData["joined_at"] as? String

        print("onTalkEvent")
        print("       id: \(id ?? "N/A")")
        print(" group_id: \(group_id ?? "N/A")")
        print("joined_at: \(joined_at ?? "N/A")")
    }

    func onChatEvent(_ additionalData: [AnyHashable: Any]) -> Void {
        let id = additionalData["id"] as? String

        print("onChatEvent")
        print("       id: \(id ?? "N/A")")
    }

    func onNewsEvent(_ additionalData: [AnyHashable: Any]) -> Void {
        print("onNewsEvent")
    }

}
