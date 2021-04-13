//
//  LoginPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-21.
//

import SwiftUI

struct LoginPopover: View {
    
    var constants = Constants()
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    
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
                    SwipeBar(height: 50, width: 3)
                        .opacity(isShowingLoginButton ? 1 : 0)
                        .offset(x: swipeOffset.width)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if gesture.translation.width < 0 {
                                        swipeOffset.width = gesture.translation.width
                                        if swipeOffset.width <= -75 {
                                            swipeOffset.width = 0
                                            swipeActivated = true
                                        }
                                    }
                                }
                        )
                }
                Divider().padding([.leading, .trailing])
                TextField("Email", text: $email)
                    .padding()
                    .onChange(of: email, perform: { value in
                        if value != "" {
                            usernameFieldHasContents = true
                        }
                    })
                SecureField("Password", text: $password)
                    .padding()
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
                self.email = ""
                self.password = ""
            }
        }
    }
    
    private var isShowingLoginButton: Bool {
        if usernameFieldHasContents && passwordFieldHasContents {
            return true
        }
        else { return false }
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
