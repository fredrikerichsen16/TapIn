//
//  Color+.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI

extension Color {
    /// Shorthand initializer to create color by RGB
	init(r: Double, g: Double, b: Double, opacity: Double = 1.0) {
		self.init(.sRGB, red: r / 255.0, green: g / 255.0, blue: b / 255.0, opacity: opacity)
	}
}
