//
//  AppDelegate.swift
//  Messenger
//
//  Created by Jens Meder on 02/04/17.
//
//

import Cocoa
import DarkLightning

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var window: NSWindow!
	var daemon: Daemon?

	func applicationDidFinishLaunching(_ aNotification: Notification) {
        let viewController = RootViewController()
        daemon = USBDaemon(delegate: viewController, deviceDelegate: viewController)
        window = NSWindow(contentRect: NSRect(x: 40, y: -500, width: 600, height: 400), styleMask: [NSTitledWindowMask,NSClosableWindowMask,NSMiniaturizableWindowMask], backing: .buffered, defer: true)
        window.title = "Messenger"
        window.contentViewController = viewController
        window.makeKeyAndOrderFront(nil)
        daemon?.start()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		daemon?.stop()
	}


}

