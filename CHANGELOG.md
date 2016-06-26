# Change Log

`DarkLightning` adheres to [Semantic Versioning](http://semver.org/).

## 1.0.0

### Additions

* Added tvOS support (example app comes with the next release)
* Added support for xcodeproj file generation via [phoenx](https://github.com/jensmeder/Phoenx)

### Changes

* Restructured repository
* Moved build configurations to xcconfig files

## 0.4.1

### Bugfix

* Fixed a bug that prevented Carthage from building the iOS Framework Target for iOS Simulator

## 0.4.0

### Additions

* Added implementation and documentation for `JMTaggedPacket` and `JMTaggedPacketProtocol` 
* Added state `JMMobileDevicePortStateOpening` to `JMMobileDevicePort`  
* Added return values to `close` and `open` methods of `JMMobileDevicePort`

### Changes

* Removed `JMDataPacketProtocol` protocol
* Example applications now use `JMTaggedPacketProtocol` 

## 0.3.4

### Bugfixes

* Fixed a bug that created an EXC_BAD_ACCESS if `close` was called on `JMMobileDevicePort` while in `JMMobileDevicePortStateIdle`

## 0.3.3

### Additions

* Added some more documentation

## 0.3.2

### Bugfixes

* Fixed a bug that prevented cocoadocs from parsing the podspec

## 0.3.1

### Changes

* Moved processing of `NSStreamDelegate` to background thread

### Additions

* More unit tests added

### Bugfixes

* Fixed a bug that prevented the `JMSocketConnectionConnecting` state on `JMSocketConnection`

## 0.3.0

### Additions

* Added the `deviceWithSerialNumber:` to JMUSBDeviceManager to obtain a `JMUSBDevice` for a given serial number if the device is attached to the system.
* Added more unit tests
* Added documentation for `JMUSBMuxDecoder` and `JMUSBMuxEncoder`
* Added a state property for `JMUSBDeviceManager`

### Changes

* All internal socket code has been refactored and separated in `JMSocket`, `JMHostSocket`, `JMPathSocket`, `JMNativeSocket`, and `JMSocketConnection` for reuse
* All `stop` and `disconnect` methods return the value `YES` from now on

## 0.2.3

### Bugfixes

* Fixed a bug that prevented the example apps to load the embedded frameworks

## 0.2.2

### Additions

* Carthage support added

## 0.2.1

### Additions

* Travis CI integration added
* More unit tests added

### Changes

* Restructured repository to support independent build

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