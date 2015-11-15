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

@class JMUSBChannel;

/**
 * These constants indicate the state of a given JMUSBChannel.
 */
typedef NS_ENUM(NSUInteger, JMUSBChannelState)
{
	/**
	 * Indicates that there is no valid connection to the usbmuxd service
	 */
	JMUSBChannelStateDisconnected = 0,
	
	/**
	 * Indicates that the channel is attempting to connect to the usbmuxd service
	 */
	JMUSBChannelStateConnecting,

	/**
	 * Indicates that there is a valid connection to the usxmuxd service.
	 */
	JMUSBChannelStateConnected
};

@protocol JMUSBChannelDelegate <NSObject>

@optional

/**
 *  Informs the delegate that the channel has received a new data package.
 *
 *  @param channel 	The channel that has received the data
 *  @param data     The data that has been received
 */
-(void) channel:(nonnull JMUSBChannel*)channel didReceiveData:(nonnull NSData*)data;

/**
 *  Informs the delegate that there has been a problem while trying to establish a connection to the usxmuxd service
 *
 *  @param channel 	The channel that has detected a problem while trying to connect
 *  @param error    An error object providing more information
 */
-(void) channel:(nonnull JMUSBChannel*)channel didFailToOpen:(nonnull NSError *)error;

/**
 *  Informs the delegate that the state of the channel has changed
 *
 *  @param channel 	The channel that has changed its state
 *  @param state    The new state of the channel
 */
-(void) channel:(nonnull JMUSBChannel*)channel didChangeState:(JMUSBChannelState)state;

@end

/**
 *  Represents a communication channel to the usbmuxd service on OSX.
 */
@interface JMUSBChannel : NSObject

@property (nonatomic, weak) id<JMUSBChannelDelegate> delegate;

/**
 *  The current connection state of the channel.
 */
@property (nonatomic, assign, readonly) JMUSBChannelState connectionState;

///----------------------------
/// @name Connection Management
///----------------------------

/**
 *  Attempts to open the usb channel.
 */
- (void) open;

/**
 *  Closes the usb channel.
 */
- (void) close;

///------------------------
/// @name Data Transmission
///------------------------

/**
 *  Transmits the given data to the usxmuxd service.
 *
 *  @param data The data to be sent to the usxmuxd service
 *
 *  @return YES if the data has been sent successfully, NO otherwise.
 */
- (BOOL) writeData:(nonnull NSData*)data;

@end