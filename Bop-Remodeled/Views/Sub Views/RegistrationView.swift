//
//  RegistrationView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-17.
//

import SwiftUI
import Combine
import Firebase

struct RegistrationView: View {
    
    let constants = Constants()
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    private var fullName: String {
        firstName + " " + lastName
    }
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var emoji: String = ""
    
    @State private var error: String = ""
    
    @State private var firstNameFieldHasContents: Bool = false
    @State private var lastNameFieldHasContents: Bool = false
    @State private var usernameFieldHasContents: Bool = false
    @State private var passwordFieldHasContents: Bool = false
    @State private var emailFieldHasContents: Bool = false
    @State private var emojiFieldHasContents: Bool = false
    
    private var isShowingRegisterButton: Bool {
        if firstNameFieldHasContents && lastNameFieldHasContents && usernameFieldHasContents && passwordFieldHasContents && emailFieldHasContents && emojiFieldHasContents
        {
            return true
        } else {
            return false
        }
    }
    
    @State private var swipeOffset = CGSize.zero
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    
    enum Popovers {
        case name
        case email
        case username
        case password
        case emoji
    }
    
    @State private var activePopover = Popovers.name
    
    var body: some View {
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let offScreenOffset = screenHeight * 0.5 //offset to move popover offscreen
        
        ZStack {
            Background()
            
            Button(action: {
                activePopover = Popovers.name
                sessionHandler.handleOtherParentTap()
            }, label: {
                GenericBubbleView(title: "Name", subTitle: fullName, size: screenWidth * 0.3)
            }).offset(x: screenWidth * 0.3, y: -screenHeight * 0.25)
            
            Button(action: {
                activePopover = Popovers.username
                sessionHandler.handleOtherParentTap()
            }, label: {
                GenericBubbleView(title: "Username", subTitle: username, size: screenWidth * 0.35)
            }).offset(x: -screenWidth * 0.3, y: -screenHeight * 0.35)
            
            Button(action: {
                activePopover = Popovers.password
                sessionHandler.handleOtherParentTap()
            }, label: {
                GenericBubbleView(title: "Password", subTitle: "", size: screenWidth * 0.25)
            }).offset(x: screenWidth * 0.25, y: screenHeight * 0.10)
            
            Button(action: {
                activePopover = Popovers.email
                sessionHandler.handleOtherParentTap()
            }, label: {
                GenericBubbleView(title: "Email", subTitle: email, size: screenWidth * 0.5)
            }).offset(x: screenWidth * 0, y: screenHeight * 0.30)
            
            Button(action: {
                activePopover = Popovers.emoji
                sessionHandler.handleOtherParentTap()
            }, label: {
                RegisterEmojiBubbleView(title: "Emoji", subTitle: emoji, size: screenWidth * 0.6)
            }).offset(x: -screenWidth * 0.15, y: -screenHeight * 0.08)
            
            //Sign up Button
            if isShowingRegisterButton {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {signUp()}) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                                .font(Font.system(size: 54))
                        }
                    }
                }
            }
            
            if sessionHandler.isShowingPopover {
                BackgroundRectangle(screenHeight: offScreenOffset)
            }
            
            VStack {
                Spacer()
                ZStack {
                    switch activePopover {
                    case .name:
                        RegisterNamePopover(parentViewHeight: screenHeight, firstName: $firstName, lastName: $lastName, firstNameFieldHasContents: $firstNameFieldHasContents, lastNameFieldHasContents: $lastNameFieldHasContents)
                            .offset(y: sessionHandler.popoverOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 {
                                            sessionHandler.popoverOffset = gesture.translation.height
                                        }
                                    }

                                    .onEnded { _ in
                                        if abs(sessionHandler.popoverOffset) > 100 {
                                            sessionHandler.popoverOffset = screenHeight
                                            sessionHandler.handleBackgroundTap(offScreenOffset: screenHeight)
                                        } else {
                                            sessionHandler.popoverOffset = 0.0
                                        }
                                    }
                            )
                    case .email:
                        RegisterEmailPopover(parentViewHeight: screenHeight, email: $email, emailFieldHasContents: $emailFieldHasContents)
                            .offset(y: sessionHandler.popoverOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 {
                                            sessionHandler.popoverOffset = gesture.translation.height
                                        }
                                    }

                                    .onEnded { _ in
                                        if abs(sessionHandler.popoverOffset) > 100 {
                                            sessionHandler.popoverOffset = screenHeight
                                            sessionHandler.handleBackgroundTap(offScreenOffset: screenHeight)
                                        } else {
                                            sessionHandler.popoverOffset = 0.0
                                        }
                                    }
                            )
                    case .username:
                        RegisterUsernamePopover(parentViewHeight: screenHeight, username: $username, usernameFieldHasContents: $usernameFieldHasContents)
                            .offset(y: sessionHandler.popoverOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 {
                                            sessionHandler.popoverOffset = gesture.translation.height
                                        }
                                    }

                                    .onEnded { _ in
                                        if abs(sessionHandler.popoverOffset) > 100 {
                                            sessionHandler.popoverOffset = screenHeight
                                            sessionHandler.handleBackgroundTap(offScreenOffset: screenHeight)
                                        } else {
                                            sessionHandler.popoverOffset = 0.0
                                        }
                                    }
                            )
                    case .password:
                        RegisterPasswordPopover(parentViewHeight: screenHeight, password: $password, passwordFieldHasContents: $passwordFieldHasContents)
                            .offset(y: sessionHandler.popoverOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 {
                                            sessionHandler.popoverOffset = gesture.translation.height
                                        }
                                    }

                                    .onEnded { _ in
                                        if abs(sessionHandler.popoverOffset) > 100 {
                                            sessionHandler.popoverOffset = screenHeight
                                            sessionHandler.handleBackgroundTap(offScreenOffset: screenHeight)
                                        } else {
                                            sessionHandler.popoverOffset = 0.0
                                        }
                                    }
                            )
                    case .emoji:
                        RegisterEmojiPopover(parentViewHeight: screenHeight, emojiText: $emoji, emojiFieldHasContents: $emojiFieldHasContents)
                            .offset(y: sessionHandler.popoverOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.height > 0 {
                                            sessionHandler.popoverOffset = gesture.translation.height
                                        }
                                    }

                                    .onEnded { _ in
                                        if abs(sessionHandler.popoverOffset) > 100 {
                                            sessionHandler.popoverOffset = screenHeight
                                            sessionHandler.handleBackgroundTap(offScreenOffset: screenHeight)
                                        } else {
                                            sessionHandler.popoverOffset = 0.0
                                        }
                                    }
                            )
                            
                    }
                }
            }.ignoresSafeArea(.container)
            .onAppear(perform: {
                sessionHandler.popoverOffset = offScreenOffset
            })
        }
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func signUp() {
        authenticationHandler.signUp(email: email ,password: password) { (result, error) in
            if let error = error {
                print(error)
                self.error = error.localizedDescription
            }
            else {
                let currentUserAuthId = Auth.auth().currentUser?.uid ?? ""
                
                UIApplication.shared.registerForRemoteNotifications()
                
                authenticationHandler.writeNewUserToInfoDatabase (
                    username: self.username,
                    email: self.email,
                    firstName: self.firstName,
                    lastName: self.lastName,
                    //birthday: self.birthday,
                    //dateJoined: Date()
                    authId: currentUserAuthId,
                    emoji: self.emoji
                )
                self.password = ""
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .environmentObject(SessionHandler())
    }
}

