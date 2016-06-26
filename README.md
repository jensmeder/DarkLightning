[![Build Status](https://travis-ci.org/jensmeder/DarkLightning.svg)](https://travis-ci.org/jensmeder/DarkLightning)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DarkLightning.svg)](https://img.shields.io/cocoapods/v/DarkLightning.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov.io](https://codecov.io/github/jensmeder/DarkLightning/coverage.svg?branch=master)](https://codecov.io/github/jensmeder/DarkLightning?branch=master)

# DarkLightning
                      
DarkLightning is a lightweight Objective-C library to allow data transmission between iOS/tvOS devices (Lightning port, Dock connector, USB-C) and OSX (USB) at 480MBit - without jailbreaking your iOS/tvOS device. It uses the usbmuxd service on OSX to open a TCP socket connection to the iOS/tvOS device. 

## Overview

1. [Features](README.md#1-features)
2. [System requirements](README.md#2-requirements)
3. [Installation](README.md#3-installation)
4. [Usage](README.md#4-usage)
5. [Packet Protocols](README.md#5-packet-protocols)
6. [Example](README.md#6-example)
7. [License](README.md#7-license)

## 1. Features

* iOS/tvOS und OSX implementations to transmit data with up to 480 MBit via USB between iOS/tvOS and OSX
* Simulator connection for debugging with iOS/tvOS Simulator
* Information on connected iOS/tvOS devices on OSX
* Callbacks for newly connected and disconnected iOS/tvOS devices on OSX

## 2. Requirements

* iOS 8.0+
* tvOS 9.0+
* Mac OS X 10.9+
* Xcode 7+ (due to new Objective-C syntax with nullability and generics)

## 3. Installation

DarkLightning is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DarkLightning"
```
There are three subspecs included: `iOS`, `tvOS` and `OSX`. CocoaPods automatically selects the correct subspec depending on the platform you are developing for. That means that `pod "DarkLightning"` and `pod "DarkLightning/iOS"` have the same effect if you are developing an iOS app.

## 4. Usage

The basic procedure to open a connection between iOS/tvOS and OSX looks like this:

1. Start a `JMMobileDevicePort` on a port on iOS/tvOS
2. Discover the device on OSX
3. Establish a connection to the previously defined port on iOS/tvOS

You can send an arbitrary amount of bytes between iOS/tvOS and OSX. The data are being sent using [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol).

### 4.1 iOS/tvOS

#### 4.1.1 Initialization

```objc
JMMobileDevicePort* devicePort = [[JMMobileDevicePort alloc]initWithPort:2345];
devicePort.delegate = self;
[devicePort open];

```
#### 4.1.2 Receiving Data

```objc
-(void) mobileDevicePort:(nonnull JMMobileDevicePort*)port didReceiveData:(nonnull NSData*)data
{
  // Do something with the data
}
```

#### 4.1.3 Sending Data

```objc
NSData* data = [@"Hello World" dataUsingEncoding:NSUTF8StringEncoding];
[devicePort writeData:data];
```

### 4.2 OSX

#### 4.2.1 Initialization

```objc
JMUSBDeviceManager* manager = [[JMUSBDeviceManager alloc]init];
manager.delegate = self;
[manager start];
```

#### 4.2.2 Device Discovery

As soon as you plug in or out an iOS/tvOS device to your Mac you will receive a callback on the corresponding delegate method (`deviceManager:deviceDidAttach:` or `deviceManager:deviceDidDetach:`) of `JMUSBDeviceManager*`. You will also receive a callback on `deviceManager:deviceDidAttach:` for every iOS/tvOS device that was already attached to OSX when you started the discovery via `[manager start];`.

```objc
JMUSBDevice* _myDevice;

...

// Called for every device that is or will be attached to the system

-(void) deviceManager:(nonnull JMUSBDeviceManager*)manager deviceDidAttach:(nonnull JMUSBDevice*)device
{
  // Save the device for later usage
  
  _myDevice = device;
}

// Called for every iOS/tvOS device that has been detached from the system

-(void) deviceManager:(nonnull JMUSBDeviceManager*)manager deviceDidDetach:(nonnull JMUSBDevice*)device
{
  // Device is no longer attached to the system. Cleanup any connections and references to it.
  
  _myDevice = nil;
}
```
#### 4.2.3 Connections

With the help of a discovered `JMUSBDevice` and a port number you can now establish a connection to your iOS/tvOS app.

_Note:_ The port number needs to be identical to the one you have used to open a `JMMobileDevicePort` on iOS/tvOS.

```objc
JMUSBDeviceConnection* myDeviceConnection = [[JMUSBDeviceConnection alloc] initWithDevice:_myDevice andPort:2345];
myDeviceConnection.delegate = self;
[myDeviceConnection connect];
```
When you are done with the connection make sure to close it properly.

```objc
[myDeviceConnection disconnect];
myDeviceConnection = nil;
```

#### 4.2.4 Receiving Data

```objc
-(void) connection:(nonnull JMUSBDeviceConnection*)connection didReceiveData:(nonnull NSData*)data
{
  // Do something with the data
}
```

#### 4.2.3 Sending Data

```objc
NSData* data = [@"Hello World" dataUsingEncoding:NSUTF8StringEncoding];
[_myDeviceConnection writeData:data];
```
### 4.3 iOS/tvOS Simulator

If you do not want to keep your iOS/tvOS device connected at all time you can also use the iOS/tvOS Simulator during development. 

#### 4.3.1 iOS/tvOS

There are no changes required to your iOS/tvOS app to use DarkLightning in the iOS/tvOS Simulator. :)

#### 4.3.2 OSX

To connect to the iOS/tvOS Simulator you need to use `JMSimulatorConnection` instead of `JMUSBDeviceConnection`. `JMSimulatorConnection` and `JMUSBDeviceConnection` inherit from the same base class `JMDeviceConnection` thus having the same interface. The delegate callbacks are the same as well. 

```objc
JMSimulatorConnection* simulatorConnection = [[JMSimulatorConnection alloc]initWithPort:2347];
simulatorConnection.delegate = self;
[simulatorConnection connect];
```

You can also use `JMSimulatorConnection` to connect to your iPhone or iPhone Simulator via network. 

```objc
JMSimulatorConnection* simulatorConnection = [[JMSimulatorConnection alloc]initWithHost:@"192.168.1.5" andPort:2347];
```

## 5. Packet Protocols

DarkLightning uses a stream based approach to transmit and receive data via TCP. If you write a data chunk on one end the bytes will arrive in the right order but they might not be in one piece. If you send data chunks very fast they might even arrive as a bigger chunk. 
DarkLightning comes with two packet protocols to en- and decode packets. Each protocol allows you to send data packets of up to 4GB in size. 

## 5.1 Simple Packet Protocol

The simple packet protocol can be used to send data of the same type or in conjunction with a higher level protocol.

### 5.1.1 Encoding

```objc
JMSimpleDataPacketProtocol* packetProtocol = [[JMSimpleDataPacketProtocol alloc]init];
```

```objc
NSData* message = [@"Hello World" dataUsingEncoding:NSUTF8StringEncoding];
NSData* packet = [packetProtocol encodePacket:data];
[_myDeviceConnection writeData:packet];
```

### 5.1.2 Decoding

The packet protocol object keeps track of all incoming data. If a packet has been split into smaller pieces the packet protocol object buffers the data. The next time you call `processData:` it tries to decode the packet again. This process continues until all parts of the packet have arrived and the packet can be decoded. Therefore, it is necessary to keep a reference to the packet protocol object.

```objc
JMSimpleDataPacketProtocol* packetProtocol = [[JMSimpleDataPacketProtocol alloc]init];
```

```objc
-(void)mobileDevicePort:(JMMobileDevicePort *)port didReceiveData:(NSData *)data
{
	NSArray<NSData*>* packets = [packetProtocol processData:data];
	
	for (NSData* packet in packets)
	{
		// Do something with the packet
	}
}
```

## 5.2 Tagged Packet Protocol

The tagged packet protocol can be used to send data with different types, e.g., using one tag for each type of data. 

### 5.2.1 Encoding

```objc
static const uint16_t MESSAGE_TAG = 12345;
static const uint16_t RAW_TAG = 42;

JMTaggedPacketProtocol* packetProtocol = [[JMTaggedPacketProtocol alloc]init];
```

```objc
NSData* messageData = [@"Hello World" dataUsingEncoding:NSUTF8StringEncoding];
JMTaggedPacket* packet = [[JMTaggedPacket alloc] initWithData:messageData andTag:MESSAGE_TAG];
NSData* packetData = [packetProtocol encodePacket:data];
[_myDeviceConnection writeData:packetData];
```

```objc
uint8_t data[] = {0x00, 0x01, 0x02, 0x03};
NSData* messageData = [NSData dataWithBytes:data length:sizeof(data)];
JMTaggedPacket* packet = [[JMTaggedPacket alloc] initWithData:messageData andTag:RAW_TAG];
NSData* packetData = [packetProtocol encodePacket:data];
[_myDeviceConnection writeData:packetData];
```

### 5.2.2 Decoding

The packet protocol object keeps track of all incoming data. If a packet has been split into smaller pieces the packet protocol object buffers the data. The next time you call `processData:` it tries to decode the packet again. This process continues until all parts of the packet have arrived and the packet can be decoded. Therefore, it is necessary to keep a reference to the packet protocol object.

```objc
JMTaggedPacketProtocol* packetProtocol = [[JMTaggedPacketProtocol alloc]init];
```

```objc
-(void)mobileDevicePort:(JMMobileDevicePort *)port didReceiveData:(NSData *)data
{
	NSArray<JMTaggedPacket*>* packets = [packetProtocol processData:data];
	
	for (JMTaggedPacket* packet in packets)
	{
		switch(packet.tag)
		{
			case MESSAGE_TAG:
			{
				// Do something with the packet data
			
				break;
			}
			
			case RAW_TAG:
			{
				// Do something with the packet data
			
				break;
			}
		}
	}
}
```

## 6. Example

The Example (see _Example_ folder) is a simple messenger that uses DarkLightning to send text messages from iOS/tvOS to OSX and vice versa. 

_Note_: The iOS/tvOS application needs to be launched before the OSX part. The OSX part will try to connect to the first device that has been attached via USB. If there are no attached devices it tries to connect to the iOS/tvOS Simulator.

## 7. License

The MIT License (MIT)

Copyright (c) 2015 Jens Meder

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
