//
//  UserDatabase.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-23.
//

import Foundation
import SwiftUI

//Model to hold user data and interface with user database
struct UserDatabase {
    
    var parsedContactsSorted: [ContactBubbleData] = []
    var contactIsSelected: [Contact] = []
    
    var myContacts: [Contact] = [Contact(initials: "BT", name: "Brad Thomas", score: 250000, emoji: "👨‍💻", pending: false),
                                 Contact(initials: "BG", name: "Bo Glaser", score: 9000, emoji: "🙅‍♂️", pending: false),
                                 Contact(initials: "DM", name: "Dexter Michaels", score: 80000, emoji: "🎃", pending: false),
                                 Contact(initials: "NC", name: "Noah Curry", score: 5, emoji: "🙂", pending: false),
                                 Contact(initials: "CP", name: "Chad Pfeifer", score: 400000, emoji: "😏", pending: true),
                                 Contact(initials: "KT", name: "Kim Thomas", score: 500000, emoji: "🤪", pending: true),
                                 Contact(initials: "MT", name: "Mike Thomas", score: 550000, emoji: "🥃", pending: true),
                                 Contact(initials: "KT", name: "Kerri-Anne Thomas", score: 700000, emoji: "👩‍🍳", pending: true),
                                 Contact(initials: "GG", name: "Graham Gillies", score: 110000, emoji: "🍑", pending: true)]
    
    mutating func addContact(newContact: Contact) {
        myContacts.append(newContact)
    }
    
    mutating func parseContacts() {
        
        var scores: [Int] = []
        var sortedContacts: [Contact]
        
        for contact in myContacts {
            scores.append(contact.score)
        }
        
        let maxScore: Int? = scores.max() ?? 1
        
        sortedContacts = myContacts.sorted(by: {($0.score < $1.score) ? true : false})
        
        parsedContactsSorted = []
        
        for contact in sortedContacts {
            let size = calculateSize(contact: contact, maxScore: CGFloat(maxScore!))
            parsedContactsSorted.append(ContactBubbleData(emoji: contact.emoji, name: contact.name, score: contact.score, size: size))
        }
    }

    mutating func calculateSize(contact: Contact, maxScore: CGFloat) -> CGFloat {
        let size: CGFloat = CGFloat(contact.score) / CGFloat(maxScore)
        return size
    }
    
    mutating func toggleContactSelectionState(_ contact: Contact) {
        if let index = myContacts.firstIndex(of: contact) {
            myContacts[index].isSelected.toggle()
        }
    }
    
    mutating func updateIsSelectedArray() {
        contactIsSelected = []
        for contact in myContacts {
            if contact.isSelected == true {
                contactIsSelected.append(contact)
            }
        }
        print(contactIsSelected)
    }
}
