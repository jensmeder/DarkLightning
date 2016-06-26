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

#pragma once

#include <stdio.h>
#include <stdint.h>
#include <CoreFoundation/CoreFoundation.h>

typedef uint32_t USBMuxPacketProtocol;

enum
{
	USBMuxPacketProtocolBinary = 0,
	USBMuxPacketProtocolPlist = 1,
};

typedef uint32_t USBMuxPacketType;

enum
{
	USBMuxPacketTypeResult = 1,
	USBMuxPacketTypeConnect = 2,
	USBMuxPacketTypeListen = 3,
	USBMuxPacketTypeDeviceAdd = 4,
	USBMuxPacketTypeDeviceRemove = 5,
	USBMuxPacketTypePlistPayload = 8,
};

typedef struct usbmux_packet_s
{
	uint32_t size;
	USBMuxPacketProtocol protocol;
	USBMuxPacketType packetType;
	uint32_t tag;
	uint8_t data[0];

} usbmux_packet_t;


uint32_t usbmux_packet_get_payload_size(usbmux_packet_t* packet);
