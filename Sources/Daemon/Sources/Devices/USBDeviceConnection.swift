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

internal final class USBDeviceConnection: Device, CustomStringConvertible {
    private let dictionary: Memory<[Int: Data]>
    private let deviceID: Int
    private let daemon: Daemon
    private let stream: WriteStream
    private let delegate: DeviceDelegate
    
    // MARK: Init
    
    internal required init(deviceID: Int, dictionary: Memory<[Int: Data]>, daemon: Daemon, stream: WriteStream, delegate: DeviceDelegate) {
        self.deviceID = deviceID
        self.dictionary = dictionary
        self.daemon = daemon
        self.stream = stream
        self.delegate = delegate
    }
    
    deinit {
        disconnect()
    }
    
    // MARK: Device
    
    internal func connect() {
        daemon.start()
    }
    
    internal func disconnect() {
        daemon.stop()
        delegate.device(didDisconnect: self)
    }
    
    internal func writeData(data: Data) {
        stream.write(data: data)
    }
    
    internal func isEqual(obj: Any) -> Bool {
        var result = false
        if let device = obj as? USBDeviceConnection {
            result = self.deviceID == device.deviceID
        }
        return result
    }
    
    // MARK: CustomStringConvertible
    
    internal var description: String {
        var result = ""
        let plist: [String: Any] = try! PropertyListSerialization.propertyList(from: dictionary.rawValue[deviceID]!, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil) as! [String : Any]
        result = String(format: "%@", plist)
        return result
    }
}
