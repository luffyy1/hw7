//
//  RandomColor.swift
//  ColorRandomizerApp
//
//  Created by Mac on 12.12.2025.
//

import Foundation

struct RandomColor: Codable {
    let hex: HexValue
    
    struct HexValue: Codable {
        let value: String 
    }
}
