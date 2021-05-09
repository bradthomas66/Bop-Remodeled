//
//  SendMessageView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-23.
//

import SwiftUI

struct SendMessageView: View {
    
    @ObservedObject var userHandler = UserHandler()
    @ObservedObject var interactionHandler = InteractionHandler()
    
    @State private var isShowingSendButton: Bool = false
    @State private var isShowingPopover: Bool = false
    @State private var sendButtonHasEverBeenTapped: Bool = false //sets popover to offscreen once tapped the first time
    
    private let constants = Constants()
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenHeight = geometry.size.height
            let offScreenOffset = screenHeight
            
            ZStack {
                Background()
                ScrollView {
                    VStack {
                        ForEach (userHandler.myContacts) { contact in
                            ContactSelectionRow (contact: contact, scoreWithCommas: contact.score.withCommas())
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
                        Button(action: { //Send button
                            if isShowingSendButton {
                                isShowingPopover = true
                                sendButtonHasEverBeenTapped = true
                                
                                interactionHandler.popoverOffset = offScreenOffset
                                
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 10)) {
                                    interactionHandler.popoverOffset = 0
                                }
                            }
                        }) {
                            ZStack {
                                Capsule()
                                    .foregroundColor(ColorManager.button)
                                    .frame(width: constants.capsuleWidth, height: constants.capsuleHeight)
                                    .padding()
                                HStack {
                                    Text("Send")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .foregroundColor(.white)
                                }
                            }
                            .opacity(isShowingSendButton ? 1 : 0)
                            .padding([.bottom, .trailing])
                        }
                    }
                }
                
                if isShowingPopover {
                    Rectangle()
                        .foregroundColor(.white)
                        .edgesIgnoringSafeArea(.all)
                        .opacity(0)
                        .onTapGesture(perform: {
                            withAnimation(.linear(duration: 0.1)) {
                                interactionHandler.popoverOffset = offScreenOffset
                            }
                            isShowingPopover = false
                        })
                }
                
                VStack {
                    Spacer()
                    if !sendButtonHasEverBeenTapped {
                        EmojiTextFieldPopover(parentViewHeight: screenHeight)
                            .offset(y: offScreenOffset)
                    } else if isShowingPopover {
                        Group {
                            EmojiTextFieldPopover(parentViewHeight: screenHeight)
                                .offset(y: interactionHandler.popoverOffset)
                        }
                    }
                }.ignoresSafeArea(.container) //This provides keyboard avoidance!
            }
            .navigationTitle("Send a Bop")
            .navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
        }
    }
    
    private func handleContactBarTap(contact: Contact) {
        if isShowingPopover == false {
            userHandler.toggleContactSelectionState(contact)
            userHandler.updateIsSelectedArray()
            print("from handle contact tap \(userHandler.contactIsSelected)")
        }
        determineButtonStatus()
        if isShowingPopover == true {
            isShowingPopover = false
        }
    }
    
    private func determineButtonStatus() {
        if !userHandler.contactIsSelected.isEmpty {
            withAnimation(.easeIn) {
                isShowingSendButton = true
            }
        }
        else {
            withAnimation(.easeOut) {
                isShowingSendButton = false
            }
        }
    }
}

struct SendMessageSubview_Previews: PreviewProvider {
    static var previews: some View {
        SendMessageView()
    }
}
