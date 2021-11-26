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
    
    @Published var sessionState: String? = nil
    
    @Published var firstTimeLogin: Bool = UserDefaults.standard.bool(forKey: "firstTimeLogin")
    
    var authState: AuthStateDidChangeListenerHandle? = nil //auth state listener, listens for auth state change and sets sessionState on change
    
    //user sign up
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password,  completion: handler) // on completion, register for notifications
    }
    
    func turnOffFirstTimeLogin() {
        firstTimeLogin = false
        UserDefaults.standard.set(false, forKey: "firstTimeLogin")
    }
    
    //user sign in
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler) // on completion, register for notifications
        
        if (firstTimeLogin) {
            firstTimeLogin = false
        } else {
            UserDefaults.standard.set(false, forKey: "firstTimeLogin")
        }
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
    
    func writeNewUserToInfoDatabase (username: String, email: String, firstName: String, lastName: String, authId: String, emoji: String) {
        let newUser = userInformationDatabaseRoot.child(username)
        let today = Date().timeIntervalSince1970
        
        let userInfo = ["authId": authId,
                        "email": email,
                        "firstName": firstName,
                        "lastName": lastName,
                        //"birthday": birthday,
                        "dateJoined": today,
                        "emoji": emoji,
                        "score": 0
        ] as [String : Any]
        newUser.setValue(userInfo)
    }
}
