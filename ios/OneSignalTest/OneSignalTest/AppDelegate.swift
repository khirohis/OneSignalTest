//
//  AppDelegate.swift
//  OneSignalTest
//
//  Created by Hirohisa Kobayasi on 2019/10/18.
//  Copyright © 2019 Hirohisa Kobayasi. All rights reserved.
//

import UIKit

import OneSignal

extension Notification.Name {
    struct FxTalk {
        struct PushNotification {
            static let Arrived = Notification.Name("FxTalk.PushNotification.Arrived")
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    struct PushConstants {
        static let FIELD_EVENT = "event"
        static let FIELD_ID = "id"
        static let FIELD_GROUP_ID = "group_id"
        static let FIELD_JOINED_AT = "joind_at"

        static let EVENT_UNKNOWN = "unknown"
        static let EVENT_TALK = "talk"
        static let EVENT_CHAT = "chat"
        static let EVENT_NEWS = "news"
    }

    class PushInfo {
        var event: String = PushConstants.EVENT_UNKNOWN
        var id: String?
        var groupId: String?
        var joinedAt: String?
    }


    var window: UIWindow?
    
    private(set) var pushInfo: PushInfo?

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
            if let event = additionalData[PushConstants.FIELD_EVENT] as? String {
                let pushInfo = PushInfo()
                pushInfo.event = event
                if let id = additionalData[PushConstants.FIELD_ID] as? String {
                    pushInfo.id = id
                }
                if let groupId = additionalData[PushConstants.FIELD_GROUP_ID] as? String {
                    pushInfo.groupId = groupId
                }
                if let joinedAt = additionalData[PushConstants.FIELD_JOINED_AT] as? String {
                    pushInfo.joinedAt = joinedAt
                }

                self.pushInfo = pushInfo

                let center = NotificationCenter.default
                center.post(name: Notification.Name.FxTalk.PushNotification.Arrived,
                            object: nil)
            }
        }
    }

    func clearPushInfo() -> Void {
        self.pushInfo = nil;
    }

}
