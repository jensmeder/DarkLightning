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

internal final class ReceivingDataReaction: DataDecoding {
	private let mapping: ([String: Any]) -> (USBMuxMessage)
    private let dataMapping: (Data) -> (OODataArray)
	
	// MARK: Init
    
    internal required init(mapping: @escaping ([String: Any]) -> (USBMuxMessage), dataMapping: @escaping (Data) -> (OODataArray)) {
        self.mapping = mapping
        self.dataMapping = dataMapping
    }
    
    // MARK: DataDecoding
	
	public func decode(data: OOData) {
        let messages = dataMapping(data.rawValue)
        for i in 0..<messages.count {
            do {
                let plist: [String: Any] = try PropertyListSerialization.propertyList(from: messages[i].rawValue, options: [], format: nil) as! [String : Any]
                let message = mapping(plist)
                message.decode()
            } catch {
                
            }
        }
	}
}
