//
//  IncomingMessages.swift
//  DarkLightning
//
//  Created by Jens Meder on 17.06.17.
//
//

import Foundation

internal final class IncomingMessages: USBMuxMessage {
	private let messages: [USBMuxMessage]
	
	internal required init(messages: [USBMuxMessage]) {
		self.messages = messages
	}
	
	func decode() {
		for message in messages {
			message.decode()
		}
	}
}
