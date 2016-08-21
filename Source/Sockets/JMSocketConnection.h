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
#import "JMSocket.h"

/**
 * These constants indicate the state of a given socket connection.
 */
typedef NS_ENUM(NSUInteger, JMSocketConnectionState)
{
	/**
	 * Indicates that there is no connection to the socket
	 */
	JMSocketConnectionStateDisconnected = 0,
	
	/**
	 * Indicates that the connection is currently trying to connect to the socket
	 */
	JMSocketConnectionStateConnecting,
	
	/**
	 * Indicates that there is a valid connection to the socket.
	 */
	JMSocketConnectionStateConnected
};

@class JMSocketConnection;

/**
 *  The JMSocketConnectionDelegate protocol defines the optional methods implemented by delegates of JMSocketConnection objects.
 */
@protocol JMSocketConnectionDelegate <NSObject>

@optional

/**
 *  Informs the delegate that the state of the connection has changed
 *
 *  @param connection The connection that has changed its state
 *  @param state      The new state of the connection
 */
-(void) connection:(nonnull JMSocketConnection*)connection didChangeState:(JMSocketConnectionState)state;

/**
 *  Informs the delegate that the connection has received a new data package.
 *
 *  @param connection The connection that has received the data
 *  @param data       The data that has been received
 */
-(void) connection:(nonnull JMSocketConnection*)connection didReceiveData:(nonnull NSData*)data;

/**
 *  Informs the delegate that there has been a problem while trying to establish a connection to the given device.
 *
 *  @param connection The connection that has detected a problem while trying to connect
 *  @param error      An error object providing more information
 */
-(void) connection:(nonnull JMSocketConnection*)connection didFailToConnect:(nonnull NSError*)error;

@end

/**
 *  Represents a connection to a given socket.
 */
@interface JMSocketConnection : NSObject

/**
 *  The underlying socket of this connection.
 */
@property (nonnull, nonatomic, strong, readonly) id<JMSocket> socket;

/**
 *  The current state of the connection.
 */
@property (readonly) JMSocketConnectionState connectionState;

/**
 *  The object that acts as the delegate of the connection.
 */
@property (nullable, nonatomic, weak) id<JMSocketConnectionDelegate> delegate;

///---------------------
/// @name Initialization
///---------------------

/**
 *  Creates a new connection with the given socket.
 *
 *  @param socket The socket the connection should be using.
 *
 *  @return A newly created socket connection if the socket is valid, nil otherwise.
 */
-(nonnull instancetype)initWithSocket:(nonnull id<JMSocket>)socket;

///----------------------------
/// @name Connection Management
///----------------------------

/**
 *  Attempts to connect to the socket.
 *
 *  @return YES if the connect was successful, NO otherwise
 */

-(void) connect;

/**
 *  Disconnects from the socket.
 *
 *  @return YES if the disconnect was successful, NO otherwise
 */
-(void) disconnect;

///------------------------
/// @name Data Transmission
///------------------------

/**
 *  Writes data to the connection if connected.
 *
 *  @param data The data that should be written to the connection.
 *
 *  @return YES if the write operation was successful, NO otherwise.
 */
-(void) writeData:(nonnull NSData*)data;

@end
