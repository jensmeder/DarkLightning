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
 * Represents a Port that can receive connections and send data.
 *
 */
public protocol Port: class, Equatable {
    /**
     *
     * Tells the Port to allow incoming connections.
     *
     */
	func open()
    
    /**
     *
     * Tells the Port to stop accepting incoming connections.
     *
     */
	func close()
    
    /**
     *
     * Tells the Port to send data.
     *
     * - parameter data: The data to be sent
     */
	func writeData(data: Data)
}

/**
 *
 * A fake implementation of the Port protocol that can be used for mocking during testing or unused parameters.
 *
 */
public final class PortFake: Port {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - Port
    
	public func open() {
		
	}
	
	public func close() {
		
	}
	
	public func writeData(data: Data) {
		
	}
    
    public func isEqual(obj: Any) -> Bool {
        var result = false
        if let _ = obj as? PortFake {
            result = true
        }
        return result
    }
}

/**
 *
 * A decorating envelop that can be used to encapsulate a graph of objects that adopt the Port protocol.
 *
 */
public class PortWrap: Port {
	private let origin: Port
	
	// MARK: - Init
	
	public init(origin: Port) {
		self.origin = origin
	}
	
	// MARK: - Port
	
	public func open() {
		origin.open()
	}
	
	public func close() {
		origin.close()
	}
	
	public func writeData(data: Data) {
		origin.writeData(data: data)
	}
    
    public func isEqual(obj: Any) -> Bool {
        var result = false
        if let port = obj as? PortWrap {
            result = origin.isEqual(obj: port)
        }
        return result
    }
}
