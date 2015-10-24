/**
 *	JMUSBDeviceConnection.h
 * 	DarkLightning
 *
 *
 *
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

#import <Foundation/Foundation.h>
#import "JMUSBDevice.h"

FOUNDATION_EXPORT NSString* _Nonnull const JMUSBDeviceConnectionErrorDomain;

FOUNDATION_EXPORT NSInteger JMUSBDeviceConnectionErrorCodeDeviceNotAvailable;
FOUNDATION_EXPORT NSInteger JMUSBDeviceConnectionErrorCodeDataStreamError;

/** 
 * These constants indicate the state of a given JMUSBDeviceConnection.
 */
typedef NS_ENUM(NSUInteger, JMUSBDeviceConnectionState)
{
	/**
	 * Indicates that there is no valid data connection to the iOS device
	 */
	JMUSBDeviceConnectionStateDisconnected = 0,

	/**
	 * Indicates that the connection is currently trying to connect to the iOS device
	 */
	JMUSBDeviceConnectionStateConnecting,

	/**
	 * Indicates that there is a valid connection to the iOS device.
	 */
	JMUSBDeviceConnectionStateConnected
};

@class JMUSBDeviceConnection;

@protocol JMUSBDeviceConnectionDelegate <NSObject>

@optional

/**
 *  Informs the delegate that the state of the connection has changed
 *
 *  @param connection The connection that has changed its state
 *  @param state      The new state of the connection
 */
-(void) connection:(nonnull JMUSBDeviceConnection*)connection didChangeState:(JMUSBDeviceConnectionState)state;

/**
 *  Informs the delegate that the connection has received a new data package.
 *
 *  @param connection The connection that has received the data
 *  @param data       The data that has been received
 */
-(void) connection:(nonnull JMUSBDeviceConnection*)connection didReceiveData:(nonnull NSData*)data;

/**
 *  Informs the delegate that there has been a problem while trying to establish a connection to the given iOS device.
 *
 *  @param connection The connection that has detected a problem while trying to connect
 *  @param error      An error object providing more information
 */
-(void) connection:(nonnull JMUSBDeviceConnection*)connection didFailToConnect:(nonnull NSError*)error;

@end

/**
 *  Represents a data connection to an iOS device.
 */
@interface JMUSBDeviceConnection : NSObject

/**
 *  The device the connection should be based on.
 *
 * @warning The device must not be nil.
 */
@property (nonnull, nonatomic, strong, readonly) JMUSBDevice* device;

/**
 *  The port the iOS is listening on.
 */
@property (nonatomic, assign, readonly) uint32_t port;

/**
 *  The current connection state. Default value is JMUSBDeviceConnectionStateDisconnected.
 */
@property (nonatomic, assign, readonly) JMUSBDeviceConnectionState state;


@property (nonatomic, weak) id<JMUSBDeviceConnectionDelegate> delegate;

///---------------------
/// @name Initialization
///---------------------

/**
 *  Initializes a connection with the given device.
 *
 *  @param device The device the connection should be established to.
 *  @param port   The port the iOS device is listening on.
 *
 *  @return A newly initialized device if device and port are valid, nil otherwise
 */
-(nullable instancetype)initWithDevice:(nonnull JMUSBDevice*)device andPort:(uint32_t)port;

///----------------------------
/// @name Connection Management
///----------------------------

/**
 *  Attempts to connect to the selected iOS device.
 */
-(void) connect;

/**
 *  Disconnects from the selected iOS device.
 */
-(void) disconnect;

///------------------------
/// @name Data Transmission
///------------------------

/**
 *  Transmits the given data to the connected iOS device.
 *
 *  @param data The data to be sent to the iOS device
 *
 *  @return YES if the connection was able to send the data, NO otherwise.
 */
-(BOOL) writeData:(nonnull NSData*)data;

@end
