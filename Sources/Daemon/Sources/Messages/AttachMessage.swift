/**
 *
 * 	DarkLightning
 *
 *
 *
 *	The MIT License (MIT)
 *
 *	Copyright (c) 2017 Jens Meder
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of
 *	this software and associated documentation files (the "Software"), to deal in
 *	the Software without restriction, including without limitation the rights to
 *	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *	the Software, and to permit persons to whom the Software is furnished to do so,
 *	subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in all
 *	copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

internal final class AttachMessage: USBMuxMessage {
	
	// MARK: Constants
	
	private static let MessageTypeAttached = "Attached"
	private static let MessageTypeKey = "MessageType"
    private static let DeviceIDKey = "DeviceID"
    private static let PropertiesKey = "Properties"
	
	// MARK: Members
	
	private let plist: [String: Any]
	private let devices: Devices
	
	// MARK: Init
	
    internal required init(plist: [String: Any], devices: Devices) {
		self.plist = plist
		self.devices = devices
	}
	
    // MARK: USBMuxMessage
	
	func decode() {
		if let messageType = plist[AttachMessage.MessageTypeKey] as? String, messageType == AttachMessage.MessageTypeAttached, let deviceID = plist[AttachMessage.DeviceIDKey] as? Int {
            let properties = plist[AttachMessage.PropertiesKey] as! [String : Any]
            let data = try! PropertyListSerialization.data(fromPropertyList: properties, format: .xml, options: 0)
            devices.insert(deviceID: deviceID, data: data)
		}
	}
}
