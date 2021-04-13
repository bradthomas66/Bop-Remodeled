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
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var fullName: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    
    @State private var error: String = ""
    
    @State private var firstNameFieldHasContents: Bool = false
    @State private var lastNameFieldHasContents: Bool = false
    @State private var usernameFieldHasContents: Bool = false
    @State private var passwordFieldHasContents: Bool = false
    @State private var emailFieldHasContents: Bool = false
    
    @State private var anyParentHasBeenTapped: Bool = false
    @State private var isShowingAnyPopover: Bool = false
    @State private var popoverOffset: CGFloat = 0.0
    
    private var isShowingRegisterBar: Bool  {
        if firstNameFieldHasContents && lastNameFieldHasContents && usernameFieldHasContents && passwordFieldHasContents && emailFieldHasContents {
            return true
        } else {
            return false
        }
    }
    
    @State private var swipeActivated: Bool = false {
        didSet {
            if swipeActivated == true {
                signUp()
            }
        }
    }
    @State private var swipeOffset = CGSize.zero
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    
    enum Popovers {
        case name
        case email
        case username
        case password
    }
    
    @State private var activePopover = Popovers.name
    
    var body: some View {
        GeometryReader { geometry in
        
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let offScreenOffset = screenHeight * 0.5 //offset to move popover offscreen
            
            VStack {
                ZStack {
                    Background()
                    
                    Button(action: {
                        isShowingAnyPopover = true
                        anyParentHasBeenTapped = true
                        activePopover = Popovers.name
                        popoverOffset = offScreenOffset //initialize popover offscreen
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.35, blendDuration: 1 )) {
                            popoverOffset = 0.0
                        }
                    }, label: {
                        GenericBubbleView(title: "Name", subTitle: fullName, size: screenWidth * 0.3)
                    }).offset(x: screenWidth * 0.3, y: -screenHeight * 0.25)
                    
                    Button(action: {
                        isShowingAnyPopover = true
                        anyParentHasBeenTapped = true
                        activePopover = Popovers.username
                        popoverOffset = offScreenOffset //initialize popover offscreen
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.35, blendDuration: 1 )) {
                            popoverOffset = 0.0
                        }
                    }, label: {
                        GenericBubbleView(title: "Username", subTitle: username, size: screenWidth * 0.35)
                    }).offset(x: -screenWidth * 0.3, y: -screenHeight * 0.35)
                    
                    Button(action: {
                        isShowingAnyPopover = true
                        anyParentHasBeenTapped = true
                        activePopover = Popovers.password
                        popoverOffset = offScreenOffset //initialize popover offscreen
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.35, blendDuration: 1 )) {
                            popoverOffset = 0.0
                        }
                    }, label: {
                        GenericBubbleView(title: "Password", subTitle: "", size: screenWidth * 0.25)
                    }).offset(x: screenWidth * 0.25)
                    
                    Button(action: {
                        isShowingAnyPopover = true
                        anyParentHasBeenTapped = true
                        activePopover = Popovers.email
                        popoverOffset = offScreenOffset //initialize popover offscreen
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.35, blendDuration: 1 )) {
                            popoverOffset = 0.0
                        }
                    }, label: {
                        GenericBubbleView(title: "Email", subTitle: email, size: screenWidth * 0.55)
                    }).offset(x: -screenWidth * 0.15, y: screenHeight * 0.25)
                    
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            SwipeBar(height: 100, width: 5)
                                .opacity(isShowingRegisterBar ? 1 : 0)
                                .offset(x: swipeOffset.width)
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            if gesture.translation.width < 0 {
                                                swipeOffset.width = gesture.translation.width
                                                if swipeOffset.width <= -75 {
                                                    swipeOffset.width = 0
                                                    if isShowingRegisterBar {
                                                        swipeActivated = true
                                                    }
                                                }
                                            }
                                        }
                                )
                                .padding(.bottom, 200)
                        }
                    }
                    
                    if isShowingAnyPopover {
                        Rectangle()
                            .foregroundColor(.white)
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.01)
                            .onTapGesture(perform: {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.35, blendDuration: 1 )) {
                                    popoverOffset = offScreenOffset
                                }
                                isShowingAnyPopover = false
                            })
                    }
                    
                    VStack {
                        Spacer()
                        if !anyParentHasBeenTapped { // if user hasnt touched the login button yet, present popover offscreen
                            ZStack {
                                switch activePopover {
                                case .name:
                                    RegisterNamePopover(parentViewHeight: screenHeight, firstName: $firstName, lastName: $lastName, fullName: $fullName, firstNameFieldHasContents: $firstNameFieldHasContents, lastNameFieldHasContents: $lastNameFieldHasContents)
                                        .offset(y: offScreenOffset)
                                case .email:
                                    RegisterEmailPopover(parentViewHeight: screenHeight, email: $email, emailFieldHasContents: $emailFieldHasContents)
                                        .offset(y: offScreenOffset)
                                case .username:
                                    RegisterUsernamePopover(parentViewHeight: screenHeight, username: $username, usernameFieldHasContents: $usernameFieldHasContents)
                                        .offset(y: offScreenOffset)
                                case .password:
                                    RegisterPasswordPopover(parentViewHeight: screenHeight, password: $password, passwordFieldHasContents: $passwordFieldHasContents)
                                        .offset(y: offScreenOffset)
                                }
                            }
                        } else {
                            ZStack {
                                switch activePopover {
                                case .name:
                                    RegisterNamePopover(parentViewHeight: screenHeight, firstName: $firstName, lastName: $lastName, fullName: $fullName, firstNameFieldHasContents: $firstNameFieldHasContents, lastNameFieldHasContents: $lastNameFieldHasContents)
                                        .offset(y: popoverOffset)
                                case .email:
                                    RegisterEmailPopover(parentViewHeight: screenHeight, email: $email, emailFieldHasContents: $emailFieldHasContents)
                                        .offset(y: popoverOffset)
                                case .username:
                                    RegisterUsernamePopover(parentViewHeight: screenHeight, username: $username, usernameFieldHasContents: $usernameFieldHasContents)
                                        .offset(y: popoverOffset)
                                case .password:
                                    RegisterPasswordPopover(parentViewHeight: screenHeight, password: $password, passwordFieldHasContents: $passwordFieldHasContents)
                                        .offset(y: popoverOffset)
                                }
                            }
                        }
                    }.ignoresSafeArea(.container)
                }
            }
        }
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func signUp() {
        authenticationHandler.signUp(email: email ,password: password)
        { (result, error) in
            if let error = error {
                print(error)
                self.error = error.localizedDescription
            }
            else {
                self.writeUserToDatabase(
                    username: self.username,
                    email: self.email,
                    firstName: self.firstName,
                    lastName: self.lastName,
                    //birthday: self.birthday,
                    //dateJoined: Date()
                    authId: Auth.auth().currentUser?.uid ?? ""
                )
                self.password = ""
            }
        }
    }
    
    private func writeUserToDatabase (username: String, email: String, firstName: String, lastName: String, authId: String) {
    let newUser = userInformationDatabaseRoot.child(authId)
    let userInfo = ["username": username,
                    "email": email,
                    "firstName": firstName,
                    "lastName": lastName,
                    //"birthday": birthday,
                    //"dateJoined": dateJoined
                    ] as [String : String]
    newUser.setValue(userInfo)
}
    
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

