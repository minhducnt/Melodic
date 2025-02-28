//
//  Color.swift
//  Melodic
//
//  Created by TMA on 26/2/25.
//

import SwiftUI

extension Color {
    // MARK: - Add colors here

    static let primarySof = fromHexString("#f48024")
    static let secondarySof = fromHexString("#50cfff")

    // MARK: - Functions

    static func fromHexString(_ hex: String) -> Color {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        return Color(red: r, green: g, blue: b)
    }
}
