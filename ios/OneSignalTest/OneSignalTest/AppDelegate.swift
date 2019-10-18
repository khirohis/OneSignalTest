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

        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "YOUR_ONESIGNAL_APP_ID",
                                        handleNotificationAction: nil,
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

}
