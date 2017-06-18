//
//  TCPMode.swift
//  DarkLightning
//
//  Created by Jens Meder on 18.06.17.
//
//

import Foundation

internal final class TCPMode: BoolValue {
	private let tcpMode: Memory<Bool>
	private let queue: DispatchQueue
	private let delegate: DeviceDelegate
	private let device: Device
	
	// MARK: Init
    
    internal required init(tcpMode: Memory<Bool>, queue: DispatchQueue, delegate: DeviceDelegate, device: Device) {
        self.tcpMode = tcpMode
		self.queue = queue
		self.delegate = delegate
		self.device = device
    }
    
    // MARK: BoolValue
	
	var boolValue: Bool {
		get {
			return tcpMode.rawValue
		}
		set {
			tcpMode.rawValue = newValue
			if newValue {
				queue.async {
					self.delegate.device(didConnect: self.device)
				}
			}
			else {
				queue.async {
					self.delegate.device(didFailToConnect: self.device)
				}
			}
		}
	}
}
