//
//  UserHandler.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-23.
//

import Foundation

class UserHandler: ObservableObject {
    
    //User model 
    @Published private(set) var userDatabase: UserDatabase = UserDatabase()
    
    //MARK: Access to the model
    var myContacts: [Contact] {
        userDatabase.myContacts
    }
    
    var parsedContactsSorted: [ContactBarData] {
        userDatabase.parsedContactsSorted
    }
    
    var contactIsSelected: [Contact] {
        userDatabase.contactIsSelected
    }
    
    //MARK: Intents 
    func addContact(_ newContact: Contact) {
        userDatabase.addContact(newContact: newContact)
    }
    
    func parseContacts() {
        userDatabase.parseContacts()
    }
    
    func toggleContactSelectionState (_ contact: Contact) {
        userDatabase.toggleContactSelectionState(contact)
    }
    
    func updateIsSelectedArray() {
        userDatabase.updateIsSelectedArray()
    }
    
    func findIndexOfContact(_ contact: Contact) -> Int {
        userDatabase.findIndexOfContact(contact)
    }

}
