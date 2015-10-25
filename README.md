# DarkLightning

DarkLightning is a lightweight Objective-C library to allow data transmission between iOS devices (Lightning port or Dock connector) and OSX (USB) at 480MBit - without jailbreaking your iOS device. It uses the usbmuxd service on OSX to open a TCP socket connection to the iOS device. 

## Overview

1. [Features](README.md#1-features)
2. [System requirements](README.md#2-requirements)
3. [Installation](README.md#3-installation)
4. [Usage](README.md#4-usage)
5. [What's next](README.md#5-whats-next)
6. [License](README.md#6-license)

## 1. Features

* iOS und OSX implementations to transmit data with up to 480 MBit via USB between iOS and OSX
* Information on connected iOS devices on OSX
* Callbacks for newly connected and disconnected iOS devices on OSX

## 2. Requirements

* iOS 8.0+
* Mac OS X 10.9+
* XCode 7+ (due to new Objective-C syntax with nullability and generics)

## 3. Installation

DarkLightning is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DarkLightning"
```
There are two subspecs included: `iOS` and `OSX`. Cocoapods automatically selects the correct subspec depending on the platform you are developing for. That means that `pod "DarkLightning"` and `pod "DarkLightning/iOS"` have the same effect if you are developing an iOS app.

## 4. Usage

### 4.1 iOS

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
[manager start];
```

#### 4.2.2 Device Discovery

As soon as you plug in or out an iOS device to your Mac you will receive a callback on the corresponding delegate method (`deviceManager:deviceDidAttach:` or `deviceManager:deviceDidDetach:`) of `JMUSBDeviceManager*`. You will also receive a callback on `deviceManager:deviceDidAttach:` for every iOS device that was already attached to OSX when you started the discovery via `[manager start];`.

```objc
JMUSBDevice* _myDevice;
```

```objc
// Called for every device that is or will be attached to the system

-(void) deviceManager:(nonnull JMUSBDeviceManager*)manager deviceDidAttach:(nonnull JMUSBDevice*)device
{
  // Save the device for later usage
  
  _myDevice = device;
}

// Called for every iOS device that has been detached from the system

-(void) deviceManager:(nonnull JMUSBDeviceManager*)manager deviceDidDetach:(nonnull JMUSBDevice*)device
{
  // Device is no longer attached to the system. Cleanup any connections and references to it.
  
  _myDevice = nil;
}
```
#### 4.2.3 Connections

With the help of a discovered `JMUSBDevice` you can now establish a connection.

```objc
JMUSBDeviceConnection* myDeviceConnection = [[JMUSBDeviceConnection alloc] initWithDevice:_myDevice andPort:2345];
myDeviceConnection.delegate = self;
[myDeviceConnection connect];
```
When you are done with the connection make sure to close it.

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
## 5. What's next

* example applications for iOS and OSX
* enhanced documentation

## 6. License

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
