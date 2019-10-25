//
//  ViewController.swift
//  OneSignalTest
//
//  Created by Hirohisa Kobayasi on 2019/10/18.
//  Copyright © 2019 Hirohisa Kobayasi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var pushInfoObservations: [NSKeyValueObservation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.pushInfo != nil {
            // set landing page to talk

            appDelegate.clearPushInfo()
        } else {
            let center = NotificationCenter.default
            center.addObserver(self,
            selector: #selector(type(of: self).onPushArrived(notification:)),
            name: Notification.Name.FxTalk.PushNotification.Arrived,
            object: nil)
        }
    }

    @objc private func onPushArrived(notification: Notification) -> Void {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if let pushInfo = appDelegate.pushInfo {
            // change page to talk
        }
    }

}
