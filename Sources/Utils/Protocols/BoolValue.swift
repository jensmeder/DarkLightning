//
//  BoolValue.swift
//  DarkLightning
//
//  Created by Jens Meder on 18.06.17.
//
//

import Foundation

internal protocol BoolValue: class {
	var boolValue: Bool {get set}
}

internal final class FakeBoolValue: BoolValue {

	// MARK: - Init
    
    internal init() {
        
    }
    
    // MARK: - BoolValue
    
    var boolValue: Bool = false
}
