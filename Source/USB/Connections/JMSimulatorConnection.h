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
#import "JMDeviceConnection.h"

/**
 *  Represents a data connection to the iOS simulator.
 */
@interface JMSimulatorConnection : JMDeviceConnection

/**
 *  The host the connection tries to connect to. Default is localhost.
 */
@property (nonnull, nonatomic, strong, readonly) NSString* host;

///---------------------
/// @name Initialization
///---------------------

/**
 *  Initializes a simulator connection with the given port on localhost
 *
 *  @param port   The port the connection is listening on.
 *
 *  @return A newly initialized device if port is valid, nil otherwise
 */
-(nonnull instancetype)initWithPort:(uint32_t)port;

/**
 *  Initializes a simulator connection with the given port and host
 *
 *  @param host	  The host the connection tries to connect to
 *  @param port   The port the connection is listening on.
 *
 *  @return A newly initialized device if port is valid, nil otherwise
 */
-(nonnull instancetype)initWithHost:(nonnull NSString*)host andPort:(uint32_t)port;

@end
