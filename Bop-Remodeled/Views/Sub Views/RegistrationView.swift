//
//  RegistrationView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-17.
//

import SwiftUI
import Combine

struct RegistrationView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var fullName: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    
    @State private var anyParentHasBeenTapped: Bool = false
    @State private var isShowingAnyPopover: Bool = false
    @State private var popoverOffset: CGFloat = 0.0
    
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
                
                
                
//                GenericBubbleView(title: "Birthday", subTitle: birthday, size: width * 0.3)
//                    .offset(x: -width * 0.05, y: -height * 0.1)
                
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
                                RegisterNamePopover(parentViewHeight: screenHeight, firstName: $firstName, lastName: $lastName, fullName: $fullName)
                                    .offset(y: offScreenOffset)
                            case .email:
                                RegisterEmailPopover(parentViewHeight: screenHeight, email: $email)
                                    .offset(y: offScreenOffset)
                            case .username:
                                RegisterUsernamePopover(parentViewHeight: screenHeight, username: $username)
                                    .offset(y: offScreenOffset)
                            case .password:
                                RegisterPasswordPopover(parentViewHeight: screenHeight, password: $password)
                                    .offset(y: offScreenOffset)
                            }
                        }
                    } else {
                        ZStack {
                            switch activePopover {
                            case .name:
                                RegisterNamePopover(parentViewHeight: screenHeight, firstName: $firstName, lastName: $lastName, fullName: $fullName)
                                    .offset(y: popoverOffset)
                            case .email:
                                RegisterEmailPopover(parentViewHeight: screenHeight, email: $email)
                                    .offset(y: popoverOffset)
                            case .username:
                                RegisterUsernamePopover(parentViewHeight: screenHeight, username: $username)
                                    .offset(y: popoverOffset)
                            case .password:
                                RegisterPasswordPopover(parentViewHeight: screenHeight, password: $password)
                                    .offset(y: popoverOffset)
                            }
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

