//
//  Character+EmojiDetection.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-30.
//  https://betterprogramming.pub/understanding-swift-strings-characters-and-scalars-a4b82f2d8fde

import Foundation

extension Character {
    
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first
        else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    var isCombinedIntoEmoji: Bool {
        unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

