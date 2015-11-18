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

#import <Kiwi/Kiwi.h>
#import "JMSocketConnection.h"
#import "JMSocketMock.h"
#include <dispatch/dispatch.h>

SPEC_BEGIN(JMSocketConnectionTests)

describe(@"JMSocketConnection",
^{
	context(@"when initializing",
	^{
		it(@"should return nil if no valid socket is passed in",
		^{
			JMSocketConnection* connection = [[JMSocketConnection alloc]initWithSocket:nil];
								
			[[connection should] beNil];
		});
	});
	
	context(@"when connecting",
			^{
				__block NSObject<JMSocketConnectionDelegate>* delegate;
				
				let(connection,
					^{
						JMSocketMock* socket = [[JMSocketMock alloc]init];
						return [[JMSocketConnection alloc]initWithSocket:socket];
					});
				
				beforeEach(
						   ^{
							   delegate = [KWMock mockForProtocol:@protocol(JMSocketConnectionDelegate)];
							   [[delegate should] conformToProtocol:@protocol(JMSocketConnectionDelegate)];
							   [delegate stub:@selector(connection:didChangeState:)];
							   [delegate stub:@selector(connection:didReceiveData:)];
							   
							   connection.delegate = delegate;
						   });
				
				it(@"should change state from disconnected to connecting to connected",
				   ^{
						   [[delegate shouldEventuallyBeforeTimingOutAfter(2)]receive:@selector(connection:didChangeState:) withCount:2];
						   [connection connect];

				   });
			});
	
	context(@"when connected",
	^{
		__block NSObject<JMSocketConnectionDelegate>* delegate;
		
		let(connection,
			^{
				JMSocketMock* socket = [[JMSocketMock alloc]init];
				return [[JMSocketConnection alloc]initWithSocket:socket];
			});
		
		beforeEach(
				   ^{
					   delegate = [KWMock mockForProtocol:@protocol(JMSocketConnectionDelegate)];
					   [[delegate should] conformToProtocol:@protocol(JMSocketConnectionDelegate)];
					   [delegate stub:@selector(connection:didChangeState:)];
					   [delegate stub:@selector(connection:didReceiveData:)];

					   connection.delegate = delegate;
				   });
		
		it(@"should receive data",
		^{
			[[delegate shouldEventuallyBeforeTimingOutAfter(2)]receive:@selector(connection:didReceiveData:)];
			[connection connect];
			
		});
		
		it(@"should be able to send a valid data object",
		^{
			NSData* data = [@"hello" dataUsingEncoding:NSUTF8StringEncoding];
			[connection connect];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				BOOL result = [connection writeData:data];
				
				[[theValue(result) shouldEventually] beTrue];
			});
		});
	});
			
});

SPEC_END
