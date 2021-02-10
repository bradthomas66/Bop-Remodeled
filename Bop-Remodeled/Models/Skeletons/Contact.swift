//
//  Contact.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-24.
//

import Foundation

struct Contact: Identifiable, Equatable {
    var initials: String
    var name: String
    var score: Int
    var emoji: String
    let id = UUID()
    var pending: Bool
    var isSelected: Bool = false
    var scores: [String: Double]? = nil
    var contacts: [Contact]? = nil
}
