//
//  JMSocketConnection.h
//  DarkLightning
//
//  Created by Jens Meder on 17/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMSocket.h"

/**
 * These constants indicate the state of a given socket connection.
 */
typedef NS_ENUM(NSUInteger, JMSocketConnectionState)
{
	/**
	 * Indicates that there is no connection to the socket
	 */
	JMSocketConnectionStateDisconnected = 0,
	
	/**
	 * Indicates that the connection is currently trying to connect to the socket
	 */
	JMSocketConnectionStateConnecting,
	
	/**
	 * Indicates that there is a valid connection to the socket.
	 */
	JMSocketConnectionStateConnected
};

@class JMSocketConnection;

@protocol JMSocketConnectionDelegate <NSObject>

@optional

/**
 *  Informs the delegate that the state of the connection has changed
 *
 *  @param connection The connection that has changed its state
 *  @param state      The new state of the connection
 */
-(void) connection:(nonnull JMSocketConnection*)connection didChangeState:(JMSocketConnectionState)state;

/**
 *  Informs the delegate that the connection has received a new data package.
 *
 *  @param connection The connection that has received the data
 *  @param data       The data that has been received
 */
-(void) connection:(nonnull JMSocketConnection*)connection didReceiveData:(nonnull NSData*)data;

/**
 *  Informs the delegate that there has been a problem while trying to establish a connection to the given device.
 *
 *  @param connection The connection that has detected a problem while trying to connect
 *  @param error      An error object providing more information
 */
-(void) connection:(nonnull JMSocketConnection*)connection didFailToConnect:(nonnull NSError*)error;

@end

@interface JMSocketConnection : NSObject

@property (nonnull, nonatomic, strong, readonly) id<JMSocket> socket;
@property (readonly) JMSocketConnectionState connectionState;
@property (nonatomic, weak) id<JMSocketConnectionDelegate> delegate;

-(nullable instancetype)initWithSocket:(nonnull id<JMSocket>)socket;

-(BOOL) connect;
-(BOOL) disconnect;

-(BOOL) writeData:(nonnull NSData*)data;

@end
