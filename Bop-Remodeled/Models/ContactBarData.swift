//
//  ContactBarData.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-25.
//

import Foundation
import SwiftUI

struct ContactBarData: Identifiable {
    let emoji: String
    let name: String
    let score: Int
    let size: CGFloat
    let pending: Bool
    let id = UUID()
}
