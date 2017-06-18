//
//  DataWithRange.swift
//  DarkLightning
//
//  Created by Jens Meder on 18.06.17.
//
//

import Foundation

internal final class DataWithRange: OOData {
	private let data: Data
	private let range: Range<Int>
	
	// MARK: Init
    
    internal required init(data: Data, range: Range<Int>) {
        self.data = data
		self.range = range
    }
    
    // MARK: OOData
	
	var dataValue: Data {
		return data.subdata(in: range)
	}
}
