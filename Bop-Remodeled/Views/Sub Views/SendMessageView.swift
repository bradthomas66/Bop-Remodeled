//
//  SendMessageView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-23.
//

import SwiftUI

struct SendMessageView: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    
    @State private var isShowingTutorial: Bool = true
    
    private var isShowingSelectButton: Bool {
        if !sessionHandler.contactIsSelected.isEmpty { return true } else { return false }
    }
    
    private let constants = Constants()
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = UIScreen.main.bounds.height
            let screenWidth = UIScreen.main.bounds.width
            let offScreenOffset = screenHeight * 0.5
            
            ZStack {
                Background()
                
                ScrollView {
                    VStack {
                        ForEach (sessionHandler.myContacts) { contact in
                            ContactSelectionRow (contact: contact, scoreWithCommas: contact.score.withCommas())
                                .onTapGesture(count: 2, perform: {
                                    sessionHandler.wipeContactSelectionState()
                                })
                                .onTapGesture(perform: {
                                    handleContactBarTap(contact: contact)
                                })
                                
                            Divider()
                        }
                    }
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { //Select button
                            if isShowingSelectButton {
                                sessionHandler.isShowingPopover = true
                                sessionHandler.popoverOffset = offScreenOffset
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 10)) {
                                    sessionHandler.popoverOffset = 0
                                }
                                if authenticationHandler.firstTimeLogin {
                                    sessionHandler.activeTutorial = "sendBop"
                                    isShowingTutorial = true
                                }
                            }
                        }) {
                            ZStack {
                                Capsule()
                                    .foregroundColor(ColorManager.button)
                                    .frame(width: constants.capsuleWidth, height: constants.capsuleHeight)
                                    .padding()
                                HStack {
                                    Text("Bop")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .foregroundColor(.white)
                                }
                            }
                            .opacity(isShowingSelectButton ? 1 : 0)
                            .padding([.bottom, .trailing])
                        }
                    }
                }
                
                if sessionHandler.isShowingPopover {
                    BackgroundRectangle(screenHeight: screenHeight)
                }
                
                VStack {
                    Spacer()
                    if sessionHandler.isShowingPopover {
                        EmojiTextFieldPopover(parentViewHeight: screenHeight)
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
                    } else {
                        EmojiTextFieldPopover(parentViewHeight: screenHeight)
                            .offset(y: offScreenOffset)
                        
                    }
                }.ignoresSafeArea(.container) //This provides keyboard avoidance
                
                if authenticationHandler.firstTimeLogin && isShowingTutorial {
                    Rectangle()
                        .foregroundColor(.black)
                        .edgesIgnoringSafeArea(.all)
                        .opacity(0.3)
                        .blur(radius: 20)
                        .onTapGesture {
                            switch sessionHandler.activeTutorial {
                            case "selectRecip": sessionHandler.activeTutorial = "bopButton"
                            case "bopButton":
                                isShowingTutorial = false
                                if sessionHandler.isShowingPopover {
                                    sessionHandler.activeTutorial = "sendBop"
                                }
                            case "sendBop": authenticationHandler.turnOffFirstTimeLogin()
                            default: authenticationHandler.turnOffFirstTimeLogin()
                            }
                        }
                    
                    switch sessionHandler.activeTutorial {
                    case "selectRecip": SelectRecipientTutorial()
                    case "bopButton": BopButtonTutorial()
                    case "sendBop": SendBopTutorial()
                    default:
                        if sessionHandler.hasSeenSendBopTutorial {
                        Text("Tap the screen to cancel")
                            .font(.footnote)
                            .foregroundColor(ColorManager.darkGrey)
                            .padding()
                            .frame(maxWidth: screenWidth * 0.42)
                            .background(ColorManager.lightGrey)
                            .cornerRadius(5)
                            .offset(x: screenWidth * 0.1, y: screenHeight * 0.3)
                            .onTapGesture {
                                authenticationHandler.turnOffFirstTimeLogin()
                            }
                        }
                    }
                }
            }.onAppear (perform: {
                sessionHandler.popoverOffset = screenHeight
                sessionHandler.isShowingPopover = false
                sessionHandler.getContacts()
            })
            .navigationTitle("Send a Bop")
            .navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
        }
    }
    
    //handles selection of contacts for sending
    private func handleContactBarTap(contact: Contact) {
        if sessionHandler.isShowingPopover == false {
            if contact.pending == false {
                sessionHandler.toggleContactSelectionState(contact)
                sessionHandler.updateIsSelectedArray()
            }
        }
        if sessionHandler.isShowingPopover == true {
            sessionHandler.isShowingPopover = false
        }
    }
}

struct SelectRecipientTutorial: View {
    @EnvironmentObject var sessionHandler: SessionHandler
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        Text("Your contacts will appear in the center of the screen. Select one or more to send a Bop to.")
            .font(.footnote)
            .foregroundColor(ColorManager.darkGrey)
            .padding()
            .frame(maxWidth: screenWidth * 0.42)
            .background(ColorManager.lightGrey)
            .cornerRadius(5)
            .onTapGesture {
                sessionHandler.activeTutorial = "BopButton"
            }
    }
}

struct BopButtonTutorial: View {
    @EnvironmentObject var sessionHandler: SessionHandler
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        Text("Once you've selected, click the Bop button at the bottom right to select an emoji")
            .font(.footnote)
            .foregroundColor(ColorManager.darkGrey)
            .padding()
            .frame(maxWidth: screenWidth * 0.42)
            .background(ColorManager.lightGrey)
            .cornerRadius(5)
            .offset(x: screenWidth * 0.1, y: screenHeight * 0.35)
            .onTapGesture {
                sessionHandler.activeTutorial = "SendBop"
            }
    }
}

struct SendBopTutorial: View {
    @EnvironmentObject var sessionHandler: SessionHandler
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Tap the circle to open the emoji keyboard.  Choose an emoji and hold your thumb on the circle to send")
                    .font(.footnote)
                    .foregroundColor(ColorManager.darkGrey)
                    .padding()
                    .frame(maxWidth: screenWidth * 0.42)
                    .background(ColorManager.lightGrey)
                    .cornerRadius(5)
                    .offset(x: 0, y: screenHeight * 0.1)
                    .onTapGesture {
                        sessionHandler.hasSeenSendBopTutorial = true
                    }
                Spacer()
            }
            Spacer()
        }
    }
}

struct SendMessageSubview_Previews: PreviewProvider {
    static var previews: some View {
        SendMessageView()
            .environmentObject(SessionHandler())
    }
}
