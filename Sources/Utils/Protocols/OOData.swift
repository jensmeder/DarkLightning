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

public protocol OOData: class {
	var rawValue: Data {get}
}

/**
 *
 * A fake implementation of the OOData protocol that can be used for mocking during testing or unused parameters.
 *
 */
public final class OODataFake: OOData {

	// MARK: - Init
    
    public init() {
        
    }
    
    // MARK: - OOData
    
	public var rawValue: Data {
		return Data()
	}
}

/**
 *
 * A decorating envelop that can be used to encapsulate a graph of objects that adopt the OOData protocol.
 *
 */
public class OODataWrap: OOData {
	private let origin: OOData
	
	// MARK: Init
	
	public init(origin: OOData) {
		self.origin = origin
	}
	
	// MARK: OOData
	
	public var rawValue: Data {
		return origin.rawValue
	}
}

