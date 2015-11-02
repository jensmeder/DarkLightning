# Change Log

`DarkLightning` adheres to [Semantic Versioning](http://semver.org/).

## 0.1.2

### Fixed

* Fixed a bug that prevented `JMMobileDevicePort` to be reopened after a remote connection was closed
* Fixed an issue where `JMUSBDeviceConnection` did not report a state change to `JMUSBDeviceConnectionStateDisconnected`

### Changes

* `JMMobileDevicePort` will now close and reopen the underlying socket if a remote USB connection was closed