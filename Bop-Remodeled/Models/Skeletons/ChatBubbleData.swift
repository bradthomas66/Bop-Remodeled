//
//  ChatBubbleData.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-12.
//

import Foundation
import SwiftUI

struct ChatBubbleData: Identifiable, Hashable {
    let content: String
    let frequency: Int
    let size: CGFloat
    let id: Int
}
