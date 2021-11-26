//
//  LoginPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-21.
//

import SwiftUI

struct LoginPopover: View {
    
    
    //This doesn't use parentView. If it sucks at scaling you know why
    
    var constants = Constants()
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    
    @State private var usernameFieldHasContents: Bool = false
    @State private var passwordFieldHasContents: Bool = false
    
    @State private var swipeActivated: Bool = false {
        didSet {
            if swipeActivated == true {
                signIn()
                UIApplication.shared.endEditing() //end keyboard editing
            }
        }
    }
    @State private var swipeOffset = CGSize.zero
    
    private var isShowingLoginButton: Bool {
        if usernameFieldHasContents && passwordFieldHasContents {
            return true
        }
        else { return false }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack {
                        Text("Login")
                            .font(.title)
                            .foregroundColor(ColorManager.backgroundTopLeft)
                            .fontWeight(.bold)
                            .padding()
                        if error != "" {
                            Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                        }
                    }
                    Spacer()
                    if isShowingLoginButton {
                        Button(action: {swipeActivated = true}) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                                .font(Font.system(size: 54))
                                .padding(.trailing)
                        }
                        
                    }
                }
                Divider().padding([.leading, .trailing])
                TextField("Email", text: $email)
                    .padding()
                    .foregroundColor(ColorManager.darkGrey)
                    .onChange(of: email, perform: { value in
                        if value != "" {
                            usernameFieldHasContents = true
                        }
                    })
                SecureField("Password", text: $password)
                    .padding()
                    .foregroundColor(ColorManager.darkGrey)
                    .onChange(of: password, perform: { value in
                        if value != "" {
                            passwordFieldHasContents = true
                        }
                    })
            }
        }
        .padding([.top, .bottom])
        .background(ColorManager.lightGrey)
        .cornerRadius(25.0)
    }
    
    private func signIn() {
        authenticationHandler.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                
                UIApplication.shared.registerForRemoteNotifications()
                
                self.email = ""
                self.password = ""
            }
        }
    }
    
}

struct LoginPopover_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            LoginPopover()
        }
    }
}
