//
//  UIColor+Hex.swift
//  ColorRandomizerApp
//
//  Created by Mac on 12.12.2025.
//

import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleaned.hasPrefix("#") {
            cleaned.removeFirst()
        }

        guard cleaned.count == 6,
              let int = Int(cleaned, radix: 16) else { return nil }

        let r = CGFloat((int >> 16) & 0xFF) / 255
        let g = CGFloat((int >> 8) & 0xFF) / 255
        let b = CGFloat(int & 0xFF) / 255

        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
