# Change Log

`DarkLightning` adheres to [Semantic Versioning](http://semver.org/).

## 0.2.0

### Additions

* Added examples for iOS and OSX
* Added a simple packet protocol
* Added a simulator connection to allow usage of DarkLightning with iOS Simulator

### Changes

* All connections now run on a separate thread

### Bugfixes

* Fixed a bug that closed the JMMobileDevicePort or JMUSBChannel connection if an empty NSData object was written to it

## 0.1.3

### Fixed

* Fixed a bug that prevented automatic CocoaPods subspec selection based on deployment platform

## 0.1.2

### Fixed

* Fixed a bug that prevented `JMMobileDevicePort` to be reopened after a remote connection was closed
* Fixed an issue where `JMUSBDeviceConnection` did not report a state change to `JMUSBDeviceConnectionStateDisconnected`

### Changes

* `JMMobileDevicePort` will now close and reopen the underlying socket if a remote USB connection was closed