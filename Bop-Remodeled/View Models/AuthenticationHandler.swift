//
//  AuthenticationHandler.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-02-03.
//

import Foundation
import SwiftUI
import Firebase

class AuthenticationHandler: ObservableObject {
    
    @Published var sessionState: String? = nil {
        didSet {
            queryCurrentUser()
        }
    } //if nil, no user is signed in, if non-nil, string is signed-in users UID
    
    var currentUser: Contact? = nil
    
    var authState: AuthStateDidChangeListenerHandle? = nil //auth state listener, listens for auth state change and sets sessionState on change
    
    //user sign up
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password,  completion: handler)
    }
    
    //user sign in
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    //user sign out
    func signOut() {
        do {
            try Auth.auth().signOut()
            sessionState = nil
        } catch {
            print ("error signing out")
        }
    }
    
    //listen for auth state changes
    func listenForAuthState() {
        authState = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.sessionState = user.uid
            } else {
                self.sessionState = nil
            }
        }
    }
    
    //stop listening for auth state changes
    func stopListening() {
        if let authState = authState {
           Auth.auth().removeStateDidChangeListener(authState)
        }
    }
    
    func queryCurrentUser() {
        let currentUserAuthId = Auth.auth().currentUser?.uid ?? "nil"
        
        databaseRoot.queryOrdered(byChild: "userInformation")
            .queryEqual(toValue: currentUserAuthId)
            .observeSingleEvent(of: .value, with: {(snapshot) in
                if !snapshot.exists() {
                    print (currentUserAuthId)
                    print ("Auth Id does not exist")
                }
                else {
                    let data = snapshot.value as? NSDictionary
                    self.currentUser?.username = data?["username"] as? String ?? ""
                    
                    print (self.currentUser?.username)
                }
            })
    }
}
