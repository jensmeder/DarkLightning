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
 * These constants indicate the state of a socket.
 */
typedef NS_ENUM(NSUInteger, JMSocketState)
{
	/**
	 * Indicates that the socket is not connected
	 */
	JMSocketStateDisconnected = 0,
	
	/**
	 * Indicates that the socket is about to be connected.
	 */
	JMSocketStateConnecting,
	
	/**
	 * Indicates that the socket is connected.
	 */
	JMSocketStateConnected
};

/**
 *  Represents a socket.
 */
@protocol JMSocket<NSObject>

/**
 *  The current state of the socket.
 */
@property (readonly) JMSocketState state;

/**
 *  The input stream can be used to retrieve data from the socket if connected. 
 *
 *  NOTE: The stream needs to be polled or scheduled in a runloop as well as opened and closed to use it.
 */
@property (nullable, nonatomic, strong, readonly) NSInputStream* inputStream;

/**
 *  The input stream can be used to write data to the socket if connected. If you want to use the stream you need to open it first.
 *
 *  NOTE: The stream needs to be polled or scheduled in a runloop as well as opened and closed to use it.
 */
@property (nullable, nonatomic, strong, readonly) NSOutputStream* outputStream;

/**
 *  Attempts to connect to the socket. If the connect was successful the input and output streams will be available.
 *
 *  @return YES if the connect was successful, NO otherwise
 */

-(BOOL) connect;

/**
 *  Disconnects the sockets and invalidates the input and output streams.
 *
 *  @return YES if the disconnect was successful, NO otherwise
 */
-(BOOL) disconnect;

@end
