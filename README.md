[![Build Status](https://api.travis-ci.org/jensmeder/DarkLightning.svg?branch=master)](https://travis-ci.org/jensmeder/DarkLightning.svg?branch=master)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DarkLightning.svg)](https://img.shields.io/cocoapods/v/DarkLightning.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov.io](https://codecov.io/github/jensmeder/DarkLightning/coverage.svg?branch=master)](https://codecov.io/github/jensmeder/DarkLightning?branch=master)

# DarkLightning
                      
DarkLightning is a lightweight Swift library to allow data transmission between iOS/tvOS devices (Lightning port, Dock connector, USB-C) and OSX (USB) at 480MBit - without jailbreaking your iOS/tvOS device. It uses the usbmuxd service on OSX to open a TCP socket connection to the iOS/tvOS device. 

## Overview

1. [Features](README.md#1-features)
2. [System requirements](README.md#2-requirements)
3. [Installation](README.md#3-installation)
4. [Usage](README.md#4-usage)
5. [Example](README.md#5-example)
6. [License](README.md#6-license)

## 1. Features

* iOS/tvOS und OSX implementations to transmit data with up to 480 MBit via USB between iOS/tvOS and OSX
* Simulator connection for debugging with iOS/tvOS Simulator
* Information on connected iOS/tvOS devices on OSX
* Callbacks for newly connected and disconnected iOS/tvOS devices on OSX

## 2. Requirements

* iOS 8.0+
* tvOS 9.0+
* Mac OS X 10.10+
* Xcode 8.3

## 3. Installation

DarkLightning is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DarkLightning"
```
There are three subspecs included: `iOS`, `tvOS` and `OSX`. CocoaPods automatically selects the correct subspec depending on the platform you are developing for. That means that `pod "DarkLightning"` and `pod "DarkLightning/iOS"` have the same effect if you are developing an iOS app.

## 4. Usage

The basic procedure to open a connection between iOS/tvOS and OSX looks like this:

1. Start a `DevicePort` on a port on iOS/tvOS
2. Discover the device on OSX
3. Establish a connection to the previously defined port on iOS/tvOS

You can send an arbitrary amount of bytes between iOS/tvOS and OSX. The data are being sent using [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol).

### 4.1 iOS/tvOS

#### 4.1.1 Initialization

```swift
let port = DevicePort(delegate: MyPortDelegate())
port.open()

```
#### 4.1.2 Receiving Data

```swift
public func port(port: DarkLightning.Port, didReceiveData data: OOData) {

}
```

#### 4.1.3 Sending Data

```swift
let data = "Hello World".data(using: .utf8)
port.writeData(data: data!)
```

### 4.2 OSX

#### 4.2.1 Initialization

```swift
let daemon = USBDaemon(delegate: MyDaemonDelegate(), deviceDelegate: MyDeviceDelegate())
daemon.start()
```

#### 4.2.2 Device Discovery

As soon as you plug in or out an iOS/tvOS device to your Mac you will receive a callback on the corresponding delegate method (`daemon(_:didAttach:)` or `daemon(_:didDetach:)`) of `USBDaemon`. You will also receive a callback on `daemon(_:didAttach:)` for every iOS/tvOS device that was already attached to OSX when you started the discovery via `daemon.start()`.

```swift

// Called for every device that already is or will be attached to the system

public func daemon(_ daemon: Daemon, didAttach device: Device) {
     
}

// Called for every iOS/tvOS device that has been detached from the system

public func daemon(_ daemon: Daemon, didDetach device: Device) {
        
}
```
#### 4.2.3 Connections

With the help of a discovered `Device` you can now establish a connection to your iOS/tvOS app.

```swift
device.connect()
```
When you are done with the connection make sure to close it properly.

```swift
device.disconnect()
```

#### 4.2.4 Receiving Data

```swift
public func device(_ device: Device, didReceiveData data: OOData) {
		
}
```

#### 4.2.3 Sending Data

```swift
let data = "Hello World".data(using: .utf8)
device.writeData(data: data!)
```

## 5. Example

The Example (see _Example_ folder) is a simple messenger that uses DarkLightning to send text messages from iOS/tvOS to OSX and vice versa. 

_Note_: The iOS/tvOS application needs to be launched before the OSX part. The OSX part will try to connect to the first device that has been attached via USB. If there are no attached devices it tries to connect to the iOS/tvOS Simulator.

## 6. License

The MIT License (MIT)

Copyright (c) 2017 Jens Meder

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
