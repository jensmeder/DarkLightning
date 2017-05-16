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

/**
 *
 * The delegate of a Device object. Adopt this protocol to receive callbacks for device related events.
 *
 */
public protocol DeviceDelegate: class {
    /**
     * 
     * Tells the delegate that a device did disconnect
     *
     * - parameter device: The device that did disconnect
     */
    func device(didDisconnect device: Device)
    
    /**
     *
     * Tells the delegate that a device did connect
     *
     * - parameter device: The device that did connect
     */
    func device(didConnect device: Device)
    
    /**
     *
     * Tells the delegate that a device did fail to connect
     *
     * - parameter device: The device that did fail to connect
     */
    func device(didFailToConnect device: Device)
    
    /**
     *
     * Tells the delegate that a device has received data
     *
     * - parameter device: The device that did receive data
     * - paramter data: The data that has been received
     */
	func device(_ device: Device, didReceiveData data: OOData)
}

/**
 *
 * A fake implementation of the DeviceDelegate protocol that can be used for mocking during testing or unused parameters.
 *
 */
public final class DeviceDelegateFake: DeviceDelegate {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - DeviceDelegate
    
    public func device(didConnect device: Device) {
        
    }
    
    public func device(didFailToConnect device: Device) {
        
    }
    
    public func device(didDisconnect device: Device) {
        
    }
	
	public func device(_ device: Device, didReceiveData data: OOData) {
		
	}
}
