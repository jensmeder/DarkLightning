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
 *  Represents a data packet with tag that can be used to send different types of data with the same protocol. The maximum size of a packet is 2^32 bytes (~ 4GB).
 */
@interface JMTaggedPacket : NSObject

@property (readonly) uint32_t length;

/**
 *  A user defined tag for the data packet.
 */
@property (readonly) uint16_t tag;

/**
 *  The actual data that should be transmitted.
 */
@property (nonnull, nonatomic, strong, readonly) NSData* data;

@property (nonnull, nonatomic, copy, readonly) NSData* encodedPacket;

/**
 *  Creates and initializes a new packet using a user defined tag.
 *
 *  @param tag  A user defined tag for the data packet.
 *
 *  @return A newly initialized packet
 */
-(nonnull instancetype)initWithTag:(uint16_t) tag;

/**
 *  Creates and initializes a new packet using an NSData object and a user defined tag.
 *
 *  @param data The actual data that should be transmitted.
 *  @param tag  A user defined tag for the data packet.
 *
 *  @return A newly initialized packet
 */
-(nonnull instancetype)initWithData:(nonnull NSData*)data andTag:(uint16_t) tag length:(uint32_t)length NS_DESIGNATED_INITIALIZER;

@end
