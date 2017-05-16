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
 * The delegate of a Daemon object. Adopt this protocol to receive callbacks for device attach and detach events.
 *
 */
public protocol DaemonDelegate: class {
    /**
     *
     * Tells the delegate that a new device has been attached to the daemon
     *
     * - parameter daemon: The daemon to which the device has been attached
     * - parameter device: The actual device that has been attached
     */
    func daemon(_ daemon: Daemon, didAttach device: Device)
    
    /**
     *
     * Tells the delegate that a device has been detached from the daemon
     *
     * - parameter daemon: The daemon from which the device has been detached
     * - parameter device: The actual device that has been detached
     */
    func daemon(_ daemon: Daemon, didDetach device: Device)
}

/**
 *
 * A fake implementation of the DaemonDelegate protocol that can be used for mocking during testing or unused parameters.
 *
 */
public final class DaemonDelegateFake: DaemonDelegate {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - DaemonDelegate
    
    public func daemon(_ daemon: Daemon, didAttach device: Device) {
        
    }
    
    public func daemon(_ daemon: Daemon, didDetach device: Device) {
        
    }
}
