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

typedef NS_ENUM(uint32_t, JMUSBMuxResultCode)
{
	JMUSBMuxResultCodeOK 				= 0,
	JMUSBMuxResultCodeBadCommand 		= 1,
	JMUSBMuxResultCodeBadDevice 		= 2,
	JMUSBMuxResultCodeConnectionRefused = 3,
	JMUSBMuxResultCodeBadVersion 		= 6
};

@class JMUSBMuxDecoder;

/**
 *  The JMUSBMuxDecoderDelegate protocol defines the optional methods implemented by delegates of JMUSBMuxDecoder objects.
 */
@protocol JMUSBMuxDecoderDelegate <NSObject>

@optional

/**
 *  Informs the delegate that a usbmuxd result code packet has been decoded.
 *
 *  @param decoder    The decoder that has decoded the result code packet.
 *  @param resultCode The usbmuxd result code.
 */
-(void) decoder:(nonnull JMUSBMuxDecoder *)decoder didDecodeResultPacket:(JMUSBMuxResultCode)resultCode;

/**
 *  Informs the delegate that a usbmuxd device attach packet has been decoded.
 *
 *  @param decoder The decoder that has decoded the device attach packet.
 *  @param device  The device that has been attached.
 */
-(void) decoder:(nonnull JMUSBMuxDecoder *)decoder didDecodeAttachPacket:(nonnull JMUSBDevice*)device;

/**
 *  Informs the delegate that a usbmuxd device detach packet has been received
 *
 *  @param decoder  The decoder that has decoded the device detach packet.
 *  @param deviceID The device id of the device that has been detached.
 */
-(void) decoder:(nonnull JMUSBMuxDecoder *)decoder didDecodeDetachPacket:(nonnull NSNumber*)deviceID;

@end

/**
 *  Represents a decoder for the plist packets of the usbmuxd service on OSX.
 */
@interface JMUSBMuxDecoder : NSObject

/**
 *  The object that acts as the delegate of the decoder.
 */
@property (nullable, nonatomic, weak) id<JMUSBMuxDecoderDelegate> delegate;

/**
 *  Processes the given data packet by trying to extract plist data from it.
 *
 *  @param data The data to be processed.
 *
 *  @return YES if the processing was successful, NO otherwise.
 */
-(void) processData:(nonnull NSData*)data;

@end
