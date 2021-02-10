//
//  String+EmojiDetection.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-30.
//

import Foundation

extension String {
  var isSingleEmoji: Bool {
    return count == 1 && containsEmoji
  }
  var containsEmoji: Bool {
    return contains { $0.isEmoji }
  }
  var containsOnlyEmoji: Bool {
    return !isEmpty && !contains { !$0.isEmoji }
  }
  var emojiString: String {
    return emojis.map { String($0) }.reduce("", +)
  }
  var emojis: [Character] {
    return filter { $0.isEmoji }
  }
  var emojiScalars: [UnicodeScalar] {
    return filter { $0.isEmoji }.flatMap { $0.unicodeScalars }
  }
}
