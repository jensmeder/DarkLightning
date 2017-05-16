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
 * Represents a Device with which you can connect and interact.
 *
 */
public protocol Device: class, Equatable {
    
    /**
     *
     * Tell the device to establish a connection.
     *
     */
	func connect()
    
    /**
     *
     * Tell the device to disconnect.
     *
     */
	func disconnect()
    
    /**
     *
     * Tell the device to write data.
     *
     * - parameter data: The actual data that should be written
     */
	func writeData(data: Data)
}

/**
 *
 * A fake implementation of the Device protocol that can be used for mocking during testing or unused parameters.
 *
 */
public final class DeviceFake: Device {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - Device
    
	public func connect() {
		
	}
	
	public func disconnect() {
		
	}
	
	public func writeData(data: Data) {
		
	}
    
    public func isEqual(obj: Any) -> Bool {
        var result = false
        if let _ = obj as? DeviceFake {
            result = true
        }
        return result
    }
}

/**
 *
 * A decorating envelop that can be used to encapsulate a graph of objects that adopt the Device protocol.
 *
 */
public class DeviceWrap: Device {
    private let origin: Device
    
    // MARK: - Init
    
    public init(origin: Device) {
        self.origin = origin
    }
    
    // MARK: - Device
    
    public func connect() {
        origin.connect()
    }
    
    public func disconnect() {
        origin.disconnect()
    }
    
    public func writeData(data: Data) {
        origin.writeData(data: data)
    }
    
    public func isEqual(obj: Any) -> Bool {
        var result = false
        if let device = obj as? DeviceWrap {
            result = origin.isEqual(obj: device)
        }
        return result
    }
}
