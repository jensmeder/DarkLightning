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

internal final class TCPMessage: DataDecoding {
    private let tcpMode: Memory<Bool>
	private let delegate: DeviceDelegate
    private let devices: Devices
	private let deviceID: Int
    private let queue: DispatchQueue
    
	// MARK: Init
    
    internal convenience init(tcpMode: Memory<Bool>, delegate: DeviceDelegate, devices: Devices, deviceID: Int) {
        self.init(
            tcpMode: tcpMode,
            delegate: delegate,
            devices: devices,
            deviceID: deviceID,
            queue: DispatchQueue.main
        )
    }
    
    internal required init(tcpMode: Memory<Bool>, delegate: DeviceDelegate, devices: Devices, deviceID: Int, queue: DispatchQueue) {
        self.tcpMode = tcpMode
		self.delegate = delegate
		self.devices = devices
		self.deviceID = deviceID
        self.queue = queue
    }
    
    // MARK: DataDecoding
    
    func decode(data: OOData) {
        if tcpMode.rawValue {
            if let device = devices.device(withID: deviceID).first {
                queue.async {
                    self.delegate.device(device, didReceiveData: data)
                }
            }
        }
    }
}
