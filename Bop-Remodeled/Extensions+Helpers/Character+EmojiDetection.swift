//
//  Character+EmojiDetection.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-30.
//

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

