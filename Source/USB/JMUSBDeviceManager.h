/**
 *	The MIT License (MIT)
 *
 *	Copyright (c) 2015 Jens Meder
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

#import <dispatch/dispatch.h>
#import "JMUSBDevice.h"

/**
 * These constants indicate the state of a given JMUSBDeviceManager.
 */
typedef NS_ENUM(NSUInteger, JMUSBDeviceManagerState)
{
	/**
	 * Indicates that there is no valid connection to the usbmuxd service.
	 */
	JMUSBDeviceManagerStateDisconnected = 0,
	
	/**
	 * Indicates that the device manager is currently trying to connect to the usbmuxd service.
	 */
	JMUSBDeviceManagerStateConnecting,
	
	/**
	 * Indicates that the device manager has a valid connection to the usbmuxd service.
	 */
	JMUSBDeviceManagerStateConnected
};

@class JMUSBDeviceManager;

/**
 *  The JMUSBDeviceManagerDelegate protocol defines the optional methods implemented by delegates of JMUSBDeviceManager objects.
 */
@protocol JMUSBDeviceManagerDelegate <NSObject>

/**
 *  Informs the delegate that the device manager has changed its state.
 *
 *  @param manager The manager that has changed its state
 *  @param state   The new state of the device manager.
 */
-(void) deviceManager:(nonnull JMUSBDeviceManager*)manager deviceDidChangeState:(JMUSBDeviceManagerState)state;

/**
 *  Informs the delegate that a new iOS device has been attached to the system. This
 * 	method is also being called during initialization of the device manager for every
 * 	device that is already attached to the system.
 *
 *  @param manager The manager that has received the attach event from usxmuxd
 *  @param device  The newly attached device
 */
-(void) deviceManager:(nonnull JMUSBDeviceManager*)manager deviceDidAttach:(nonnull JMUSBDevice*)device;

/**
 *  Informs the delegate that previously attached iOS device has been detached from the system
 *
 *  @param manager The manager that has received the detach event from usxmuxd
 *  @param device  The detached device
 */
-(void) deviceManager:(nonnull JMUSBDeviceManager*)manager deviceDidDetach:(nonnull JMUSBDevice*)device;

@end

/**
 *  The device manager keeps track of all iOS devices that are being attached or detached to the system.
 */
@interface JMUSBDeviceManager : NSObject

/**
 *  The current state of the device manager. Default value is JMUSBDeviceManagerStateDisconnected.
 */
@property (readonly) JMUSBDeviceManagerState state;

/**
 *  A collection of all devices that are currently attached to the system.
 */
@property (nonnull, nonatomic, copy, readonly) NSArray<JMUSBDevice*>* attachedDevices;

/**
 *  The object that acts as the delegate of the manager.
 */
@property (nullable, nonatomic, weak) id<JMUSBDeviceManagerDelegate> delegate;

///----------------------------
/// @name Listening for devices
///----------------------------

/**
 *  Start listening for attach and detach events.
 */
- (BOOL) start;

/**
 *  Stop listening for attach and detach events.
 */
- (BOOL) stop;

///------------------------
/// @name Device Management
///------------------------

/**
 *  Returns the JMUSBDevice for the given serial number.
 *
 *  @param serialNumber The serial number of the device to be retrieved
 *
 *  @return The JMUSBDevice for the given serial number, nil otherwise.
 */
-(nullable JMUSBDevice*) deviceWithSerialNumber:(nonnull NSString*)serialNumber;

@end
