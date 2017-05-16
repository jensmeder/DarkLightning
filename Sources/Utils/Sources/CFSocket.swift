/**
 *
 * 	DarkLightning
 *
 *
 *
 *	The MIT License (MIT)
 *
 *	Copyright (c) 2017 Jens Meder
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

import Foundation

let CFSocketInvalidHandle: Int32 = -1

internal func CFSocketSetOption(socket: CFSocket, option: Int32, aValue: Int) {
	var value = aValue
	setsockopt(
		CFSocketGetNative(socket),
		SOL_SOCKET,
		option,
		&value,
		socklen_t(MemoryLayout<Int>.size)
	)
}

internal func CFSocketConfigureAddress(socket: CFSocket, address: UInt32, port: UInt16) {
	var sin =  sockaddr_in(
		sin_len: UInt8(MemoryLayout<sockaddr_in>.size),
		sin_family: sa_family_t(AF_INET),
		sin_port: NetworkUInt16(origin: port).rawValue,
		sin_addr: in_addr(
			s_addr: NetworkUInt32(origin: address).rawValue
		),
		sin_zero: (0,0,0,0,0,0,0,0)
	)
	let sincfd = NSData(
		bytes: &sin,
		length: MemoryLayout<sockaddr_in>.size
	)
	CFSocketSetAddress(
		socket,
		sincfd
	)
}

internal func CFSocketSetReuseFlags(socket: CFSocket) {
	CFSocketSetOption(
		socket: socket,
		option: SO_REUSEADDR,
		aValue: Int(true)
	)
	CFSocketSetOption(
		socket: socket,
		option: SO_REUSEPORT,
		aValue: Int(true)
	)
}
