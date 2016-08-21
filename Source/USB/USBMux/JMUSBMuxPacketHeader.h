//
//  JMUSBMuxPacketHeader.h
//  DarkLightning
//
//  Created by Jens Meder on 21/08/16.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(uint32_t, JMUSBMuxPacketProtocolType) {
	
	JMUSBMuxPacketProtocolTypeBinary = 0,
	JMUSBMuxPacketProtocolTypePlist  = 1,
};

typedef NS_ENUM(uint32_t, JMUSBMuxPacketType) {
	
	JMUSBMuxPacketTypeResult       = 1,
	JMUSBMuxPacketTypeConnect      = 2,
	JMUSBMuxPacketTypeListen       = 3,
	JMUSBMuxPacketTypeDeviceAdd    = 4,
	JMUSBMuxPacketTypeDeviceRemove = 5,
	JMUSBMuxPacketTypePlistPayload = 8,
};

@interface JMUSBMuxPacketHeader : NSObject

@property (readonly) uint32_t payloadSize;
@property (readonly) JMUSBMuxPacketProtocolType protocolType;
@property (readonly) JMUSBMuxPacketType packetType;
@property (readonly) uint32_t tag;

@property (nonnull, nonatomic, copy, readonly) NSData* encodedHeader;

-(nonnull instancetype)initWithData:(nonnull NSData*)data;
-(nonnull instancetype)initWithPayloadSize:(uint32_t)payloadSize protocolType:(JMUSBMuxPacketProtocolType)protocolType packetType:(JMUSBMuxPacketType)packetType tag:(uint32_t)tag NS_DESIGNATED_INITIALIZER;

@end
