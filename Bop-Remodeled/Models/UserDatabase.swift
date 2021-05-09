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
    
    var parsedContactsSorted: [ContactBarData] //array containing contacts sorted
    var contactIsSelected: [Contact] {
        didSet {
            print("Someone changed me!")
        }
    } //array containing the contacts currently selected
    var myContacts: [Contact] {
        didSet {
            parseContacts()
        }
    }
    
    init() {
        //load contacts from server (simulated by "contactSample")
        myContacts = contactSample
        contactIsSelected = []
        parsedContactsSorted = []
        parseContacts()
    }
    
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
        
        sortedContacts = myContacts.sorted(by: {($0.score > $1.score) ? true : false})
        
        parsedContactsSorted = []
        
        for contact in sortedContacts {
            let size = calculateSize(contact: contact, maxScore: CGFloat(maxScore!))
            parsedContactsSorted.append(ContactBarData(emoji: contact.emoji, name: contact.firstName, score: contact.score, size: size))
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
