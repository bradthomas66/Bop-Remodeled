//
//  ContactBubbleData.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-25.
//

import Foundation
import SwiftUI

struct ContactBubbleData: Identifiable {
    let emoji: String
    let name: String
    let score: Int
    let size: CGFloat
    let id = UUID()
    var zoomScalar: CGFloat = 1.0
}
