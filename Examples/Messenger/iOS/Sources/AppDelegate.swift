//
//  AppDelegate.swift
//  Messenger-iOS
//
//  Created by Jens Meder on 05.04.17.
//
//

import UIKit
import DarkLightning

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var port: DarkLightning.Port?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let textView = Memory<UITextView?>(initialValue: nil)
        let navigationItem = Memory<UINavigationItem?>(initialValue: nil)
        port = DevicePort(delegate: MessengerDelegate(textView: textView, navigationItem: navigationItem))
        port?.open()
		window = UIWindow()
        window?.rootViewController = UINavigationController(
            rootViewController: ViewController(
                title: "Disconnected",
                textView: textView,
                header: navigationItem,
                port: port!
            )
        )
		window?.makeKeyAndVisible()
        application.isIdleTimerDisabled = true
        return true
    }


}

