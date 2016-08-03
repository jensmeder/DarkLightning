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

#import "JMSocket.h"

/**
 *  Represents a socket to a given host.
 */
@interface JMHostSocket : NSObject<JMSocket>

/**
 *  The port to which the socket is bound to.
 */
@property (readonly) uint32_t port;

/**
 *  The host to which the socket is bound to.
 */
@property (nonnull, nonatomic, strong, readonly) NSString* host;

///---------------------
/// @name Initialization
///---------------------

/**
 *  Initializes and returns a newly
 *
 *  @param host The host to which the socket should be bound to.
 *  @param port The port to which the socket should be bound to.
 *
 *  @return A newly initialized socket if the given host and port are valid, nil otherwise.
 */
-(nonnull instancetype)initWithHost:(nonnull NSString*)host andPort:(uint32_t)port;

@end
