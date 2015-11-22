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

#import <Foundation/Foundation.h>

/**
 *  The error domain for all device connection related errors
 */
FOUNDATION_EXPORT NSString* _Nonnull const JMDeviceConnectionErrorDomain;

/**
 *  Indicates that the device is not avaiable.
 */
FOUNDATION_EXPORT NSInteger JMDeviceConnectionErrorCodeDeviceNotAvailable;

/**
 *  Indicates that there has been some error with one of the underlying streams.
 */
FOUNDATION_EXPORT NSInteger JMDeviceConnectionErrorCodeDataStreamError;

/**
 * These constants indicate the state of a given JMDeviceConnection.
 */
typedef NS_ENUM(NSUInteger, JMDeviceConnectionState)
{
	/**
	 * Indicates that there is no valid data connection to the device
	 */
	JMDeviceConnectionStateDisconnected = 0,
	
	/**
	 * Indicates that the connection is currently trying to connect to the device
	 */
	JMDeviceConnectionStateConnecting,
	
	/**
	 * Indicates that there is a valid connection to the device.
	 */
	JMDeviceConnectionStateConnected
};

@class JMDeviceConnection;

/**
 *  The JMDeviceConnectionDelegate protocol defines the optional methods implemented by delegates of JMDeviceConnection objects.
 */
@protocol JMDeviceConnectionDelegate <NSObject>

@optional

/**
 *  Informs the delegate that the state of the connection has changed
 *
 *  @param connection The connection that has changed its state
 *  @param state      The new state of the connection
 */
-(void) connection:(nonnull JMDeviceConnection*)connection didChangeState:(JMDeviceConnectionState)state;

/**
 *  Informs the delegate that the connection has received a new data package.
 *
 *  @param connection The connection that has received the data
 *  @param data       The data that has been received
 */
-(void) connection:(nonnull JMDeviceConnection*)connection didReceiveData:(nonnull NSData*)data;

/**
 *  Informs the delegate that there has been a problem while trying to establish a connection to the given device.
 *
 *  @param connection The connection that has detected a problem while trying to connect
 *  @param error      An error object providing more information
 */
-(void) connection:(nonnull JMDeviceConnection*)connection didFailToConnect:(nonnull NSError*)error;

@end

/**
 *  JMDeviceConnection is an abstract class for objects representing connections to devices. Its interface is common to 
 *  all device connection classes, including its concrete subclasses JMSimulatorConnection and JMUSBDeviceConnection.
 */
@interface JMDeviceConnection : NSObject

/**
 *  The port the iOS is listening on.
 */
@property (nonatomic, assign, readonly) uint32_t port;

/**
 *  The current connection state. Default value is JMDeviceConnectionStateDisconnected.
 */
@property (nonatomic, assign, readonly) JMDeviceConnectionState state;

/**
 *  The object that acts as the delegate of the connection.
 */
@property (nonatomic, weak) id<JMDeviceConnectionDelegate> delegate;

///---------------------
/// @name Initialization
///---------------------

/**
 *  Initializes a connection with the given port.
 *
 *  @param port   The port the connection is listening on.
 *
 *  @return A newly initialized connection
 */
-(nullable instancetype)initWithPort:(uint32_t)port;

///----------------------------
/// @name Connection Management
///----------------------------

/**
 *  Attempts to connect to the device.
 *
 *  @return YES if the connect was successful, NO otherwise
 */

-(BOOL) connect;

/**
 *  Disconnects from the device.
 *
 *  @return YES if the disconnect was successful, NO otherwise
 */
-(BOOL) disconnect;

///------------------------
/// @name Data Transmission
///------------------------

/**
 *  Transmits the given data to the connected device.
 *
 *  @param data The data to be sent to the device
 *
 *  @return YES if the connection was able to send the data, NO otherwise.
 */
-(BOOL) writeData:(nonnull NSData*)data;

@end
