//
//  Collection+.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 15/08/2021.
//

import Cocoa

extension Collection {

    /// Safely access a specific index of a collection. Output optional.
    /// - Parameter index: index to access
    /// - Returns: Optional element
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
