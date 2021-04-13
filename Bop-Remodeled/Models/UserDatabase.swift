//
//  UserDatabase.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-23.
//

import Foundation
import SwiftUI
import Firebase

//Model to hold user data and interface with user database
struct UserDatabase {
    
    var parsedContactsSorted: [ContactBubbleData] = [] //
    var contactIsSelected: [Contact] = []
    
    var myContacts: [Contact] = [Contact(initials: "BT", firstName: "Brad", lastName: "Thomas", score: 250000, username: "Coolguy", emoji: "👨‍💻", pending: false),
                                 Contact(initials: "BG", firstName: "Bo", lastName: "Glaser", score: 9000, username: "Dickbutt", emoji: "🙅‍♂️", pending: false),
                                 Contact(initials: "DM", firstName: "Dexter", lastName: "Michaels", score: 80000, username: "Bobyjoe", emoji: "🎃", pending: false),
                                 Contact(initials: "NC", firstName: "Noah", lastName: "Curry", score: 5, username: "noah", emoji: "🙂", pending: false),
                                 Contact(initials: "CP", firstName: "Chad", lastName: "Pfeifer", score: 400000, username: "chadloveskaylee69", emoji: "😏", pending: true),
                                 Contact(initials: "KT", firstName: "Kim", lastName: "Thomas", score: 500000, username: "Tiger113", emoji: "🤪", pending: true),
                                 Contact(initials: "MT", firstName: "Mike", lastName: "Thomas", score: 550000, username: "mthoma", emoji: "🥃", pending: true),
                                 Contact(initials: "KT", firstName: "Kerri-Anne", lastName: "Thomas", score: 700000, username: "Kimbrad", emoji: "👩‍🍳", pending: true),
                                 Contact(initials: "GG", firstName: "Graham", lastName: "Gillies", score: 110000, username: "exboyfriend", emoji: "🍑", pending: true)] {
        didSet {
            parseContacts()
        }
    }
    
    mutating func addContact(newContact: Contact) {
        myContacts.append(newContact)
    }
    
    mutating func parseContacts() {
        
        print("parsing contacts...")
        
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
            parsedContactsSorted.append(ContactBubbleData(emoji: contact.emoji, name: contact.firstName, score: contact.score, size: size))
        }
        
        print ("done parsing contacts")
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
    
    func findIndexOfContact(_ contact: Contact) -> Int {
        if myContacts.contains(contact) {
            guard let index = myContacts.firstIndex(of: contact) else { return 1 }
            return index
        } else {
            return 1
        }
    }
    
}
