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
#import "JMTaggedPacket.h"

@interface JMDecodedTaggedPackets : NSObject

@property (nonnull, nonatomic, strong, readonly) NSData* rawData;
@property (nonnull, nonatomic, strong, readonly) NSArray<JMTaggedPacket*>* decodedPackets;

-(nonnull instancetype)initWithRawData:(nonnull NSData*)data andDecodedMessages:(nonnull NSArray<JMTaggedPacket*>*) decodedPackets NS_DESIGNATED_INITIALIZER;

/**
 *  Processes the given data to extract data packets from it.
 *
 *  @param data The data that should be processed
 *
 *  @return All data packets that could be decoded from the data.
 */
-(nonnull instancetype) decodedPacketsByProcessingData:(nonnull NSData*)data;

@end
