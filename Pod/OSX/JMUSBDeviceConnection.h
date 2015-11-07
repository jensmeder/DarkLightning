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
#import "JMUSBDevice.h"
#import "JMDeviceConnection.h"

/**
 *  Represents a data connection to an iOS device.
 */
@interface JMUSBDeviceConnection : JMDeviceConnection

/**
 *  The device the connection should be based on.
 *
 * @warning The device must not be nil.
 */
@property (nonnull, nonatomic, strong, readonly) JMUSBDevice* device;

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

@end
