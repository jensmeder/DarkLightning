//
//  RootViewController.swift
//  OSX
//
//  Created by Jens Meder on 16.05.17.
//
//

import Cocoa
import DarkLightning

class RootViewController: NSViewController, RootViewDelegate, DaemonDelegate, DeviceDelegate {
    private var device: Device?
    private weak var rootView: RootView?
    
    // MARK: Init
    
    required init() {
        super.init(nibName: nil, bundle: nil)!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        weak var weakSelf = self
        let view = RootView(frame: NSRect(x: 0, y: 0, width: 600, height: 400), delegate: weakSelf!)
        view.setup()
        self.view = view
        self.rootView = view
    }
    
    // MARK: RootViewDelegate
    
    func sendMessage(message: String) {
        device?.writeData(data: message.data(using: .utf8)!)
    }
    
    // MARK: DaemonDelegate
    
    func daemon(_ daemon: Daemon, didAttach device: Device) {
        if self.device == nil {
            self.device = device
            device.connect()
        }
    }
    
    func daemon(_ daemon: Daemon, didDetach device: Device) {
        if let aDevice = self.device, device.isEqual(obj: aDevice) {
            self.device = nil
        }
    }
    
    // MARK: DeviceDelegate
    
    public func device(didConnect device: Device) {
        
    }
    
    public func device(didFailToConnect device: Device) {
        
    }
    
    public func device(didDisconnect device: Device) {
        
    }
    
    public func device(_ device: Device, didReceiveData data: OOData) {
        let message = String(data: data.dataValue, encoding: .utf8)!
        rootView?.appendMessage(message:message)
    }
    
}
