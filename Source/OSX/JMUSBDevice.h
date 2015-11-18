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
 *  Represents a single iOS device that has been discovered by usbmuxd
 */
@interface JMUSBDevice : NSObject

/**
 *  The device identifier of the device. Used to identify the device within usbmuxd service.
 */
@property (nonnull, nonatomic, strong, readonly) NSNumber* deviceID;

/**
 *  The serial number of the device, e.g., @"32b595e5cd1f122c7687bcf953bd1af120b176c6"
 */
@property (nonnull, nonatomic, strong, readonly) NSString* serialNumber;

/**
 *  The connection speed to the device. Default is 480000000.
 */
@property (nonnull, nonatomic, strong, readonly) NSNumber* connectionSpeed;

/**
 *  The product identifier of the device, e.g., 4776
 */
@property (nonnull, nonatomic, strong, readonly) NSNumber* productID;

/**
 *  The location identifier of the device, e.g., 337641472
 */
@property (nonnull, nonatomic, strong, readonly) NSNumber* locationID;

///---------------------
/// @name Initialization
///---------------------

/**
 *  Creates and initializes a new device using a plist based NSDictionary
 *
 *  @param plist The NSDictionary representation of the plist data
 *
 *  @return A newly initialized device
 */
-(nullable instancetype)initWithPList:(nonnull NSDictionary*)plist NS_DESIGNATED_INITIALIZER;

@end
