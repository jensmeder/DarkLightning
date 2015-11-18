//
//  JMSocket.h
//  DarkLightning
//
//  Created by Jens Meder on 18/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

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

@protocol JMSocket<NSObject>

@property (readonly) JMSocketState state;
@property (nullable, nonatomic, strong, readonly) NSInputStream* inputStream;
@property (nullable, nonatomic, strong, readonly) NSOutputStream* outputStream;

-(BOOL) connect;
-(BOOL) disconnect;

@end
