//
//  Contact.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-24.
//

import Foundation

struct Contact: Identifiable, Equatable {
    var firstName: String
    var lastName: String
    var score: Int
    var username: String
    var emoji: String
    var authId: String
    var pending: Bool = true
    var initials: String {
        String(firstName.prefix(1) + lastName.prefix(1))
    }
    let id = UUID()
    var isSelected: Bool = false
}

//var contactSample: [Contact] = [Contact(firstName: "Brad", lastName: "Thomas", score: 250000, username: "Coolguy", emoji: "👨‍💻", authId: "u72x1YcvfsbX4v8ttx9Cq9DnnpG3", pending: false),
//                                Contact(firstName: "Bo", lastName: "Glaser", score: 9000, username: "Coolguy2", emoji: "🙅‍♂️", authId: "weJkupPGzVbbSccfNfHI5Xo9YN62"),
//                                Contact(firstName: "Dexter", lastName: "Michaels", score: 80000, username: "Coolguy3", emoji: "🎃", authId: "oI1jFeguntWRK7TJSsjehSmLXRw1", pending: false)]
