//
//  AutoConnectDelegate.swift
//  DarkLightning
//
//  Created by Jens Meder on 05.04.17.
//
//

import Foundation
import DarkLightning
import UIKit

internal final class MessengerDelegate: DarkLightning.PortDelegate {
    private let textView: Memory<UITextView?>
    private let navigationItem: Memory<UINavigationItem?>
    
	// MARK: Init
    
    internal required init(textView: Memory<UITextView?>, navigationItem: Memory<UINavigationItem?>) {
        self.textView = textView
        self.navigationItem = navigationItem
    }
    
    // MARK: DevicePortDelegate
    
    public func port(didConnect port: DarkLightning.Port) {
        self.navigationItem.rawValue?.title = "Connected"
    }
    
    public func port(didDisconnect port: DarkLightning.Port) {
        self.navigationItem.rawValue?.title = "Disconnected"
    }
    
    public func port(port: DarkLightning.Port, didReceiveData data: OOData) {
        textView.rawValue?.text.append(String(data: data.dataValue, encoding: .utf8)!)
        textView.rawValue?.text.append("\r")
    }
}
