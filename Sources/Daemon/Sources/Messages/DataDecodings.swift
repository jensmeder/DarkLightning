//
//  DataDecodings.swift
//  DarkLightning
//
//  Created by Jens Meder on 18.06.17.
//
//

import Foundation

internal final class DataDecodings: DataDecoding {
	private let decodings: [DataDecoding]
	
	// MARK: Init
    
    internal required init(decodings: [DataDecoding]) {
        self.decodings = decodings
    }
    
    // MARK: DataDecoding
	
	func decode(data: OOData) {
		for decoding in decodings {
			decoding.decode(data: data)
		}
	}
}
