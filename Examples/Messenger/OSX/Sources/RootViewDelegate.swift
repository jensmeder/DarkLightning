//
//  RootViewDelegate.swift
//  OSX
//
//  Created by Jens Meder on 16.05.17.
//
//

import Foundation

internal protocol RootViewDelegate: class {
    func sendMessage(message: String)
}

internal final class RootViewDelegateFake: RootViewDelegate {

	// MARK: - Init
    
    internal init() {
        
    }
    
    // MARK: - RootViewDelegate
    
    func sendMessage(message: String) {
        
    }
}
