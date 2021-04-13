//
//  Contact.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-24.
//

import Foundation

struct Contact: Identifiable, Equatable {
    var initials: String
    var firstName: String
    var lastName: String
    var score: Int
    var username: String
    var emoji: String
    let id = UUID()
    var isSelected: Bool = false
    var pending: Bool
}
