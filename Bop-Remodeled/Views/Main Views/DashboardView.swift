//
//  ContentView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-12.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    
    @State private var tutorialOffset: CGFloat = UIScreen.main.bounds.width
    @State private var isShowingTutorial: Bool = true
    @State private var replyPopoverOffset: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                
                let screenHeight = UIScreen.main.bounds.height
                let screenWidth = UIScreen.main.bounds.width
                
                ZStack {
                    Background()
                    ChatBarScrollView(geometry: geometry)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            SendMessageButton()
                                .padding(.trailing)
                        }
                    }
                    
                    //this is for the normal chat info popover
                    if sessionHandler.isShowingPopover {
                        BackgroundRectangle(screenHeight: screenHeight)
                        VStack {
                            Spacer()
                            ChatBarPopover(parentViewHeight: screenHeight)
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
                    
                    //This is for reply screen popover
                    if  sessionHandler.isShowingReplyPopover {
                        Rectangle()
                            .foregroundColor(.blue)
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.01)
                            .onTapGesture(perform: {
                                UIApplication.shared.endEditing()
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 10)) {
                                    replyPopoverOffset = screenHeight
                                }
                                sessionHandler.isShowingReplyPopover = false 
                            })
                        VStack {
                            Spacer()
                            EmojiTextFieldPopover(parentViewHeight: screenHeight * 0.5)
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
                    
                    //tutorials
                    if authenticationHandler.firstTimeLogin && isShowingTutorial {
                        Rectangle()
                            .foregroundColor(.black)
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.3)
                            .blur(radius: 20)
                            .onTapGesture {
                                switch sessionHandler.activeTutorial {
                                case "chats": sessionHandler.activeTutorial = "contact"
                                case "contact": sessionHandler.activeTutorial = "addContact"
                                case "sendButton":
                                    sessionHandler.activeTutorial = "selectRecip"
                                    isShowingTutorial = false
                                case "scores": authenticationHandler.turnOffFirstTimeLogin()
                                default: if isShowingTutorial {
                                    authenticationHandler.turnOffFirstTimeLogin()
                                }
                                }
                            }
                        
                        switch sessionHandler.activeTutorial {
                        case "chats": ChatsTutorial()
                        case "contact": ContactTutorial()
                        case "addContact": ContactTutorial()
                        case "sendButton": SendButtonTutorial(isShowingTutorial: $isShowingTutorial)
                        case "selectRecip": EmptyView().onAppear(perform: {isShowingTutorial = false})
                        default:
                            if sessionHandler.hasSeenScoresTutorial {
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
                    
                }.navigationTitle("Dashboard")
                    .navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading:
                                        NavigationLink (
                                            destination: SettingsView(),
                                            label: {Image(systemName: "gearshape.fill")}
                                        ),
                                    trailing:
                                        NavigationLink (
                                            destination: ScoresView(),
                                            label: { Image(systemName: "person.3.fill").foregroundColor(.white)}
                                        ).simultaneousGesture(TapGesture().onEnded{
                                            sessionHandler.activeTutorial = "addContact"
                                        })
                )
            }
        }.onAppear(perform: {
            sessionHandler.getChats()
            sessionHandler.registerForPushNotifications()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 10)) {
                tutorialOffset = 0
            }
        })
    }
}

struct ChatBarScrollView: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    let geometry: GeometryProxy
    let constants = Constants()
    var body: some View {
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        ScrollViewReader { action in
            ScrollView () {
                ZStack {
                    //VStack spacing 0.0 is important for getting rid of dumb spacing between objects
                    VStack(spacing: 0.0) {
                        ForEach(sessionHandler.parsedChatsSorted) { chat in
                            ChatBarView(chatToBar: ChatBarData(emoji: chat.emoji, score: chat.score, size: chat.size, id: chat.id), width: screenWidth * constants.barViewGlobalBarWidth, height: screenHeight * constants.barViewGlobalBarHeight)
                                .padding(.vertical, constants.barViewGlobalPadding)
                                .onTapGesture {
                                    sessionHandler.handleBarTap(geometry: geometry, chat: chat)
                                }
                        }
                    }
                    .onReceive(sessionHandler.$activeChat, perform: { _ in
                        var activeIndex: Int
                        if sessionHandler.activeChat != nil {
                            activeIndex = sessionHandler.findIndexOfParsedChat(sessionHandler.activeChat!)
                        } else {
                            activeIndex = 1
                        }
                        if !sessionHandler.parsedChatsSorted.isEmpty {
                            action.scrollTo(activeIndex, anchor: .center)
                        }
                    })
                }.onAppear (perform: {
                    sessionHandler.popoverOffset = UIScreen.main.bounds.height
                    sessionHandler.isShowingPopover = false
                })
            }
        }
    }
}

struct SendMessageButton: View {
    
    let constants = Constants()
    
    var body: some View {
        ZStack {
            NavigationLink (
                destination: SendMessageView(),
                label: {
                    Circle()
                        .stroke(lineWidth: constants.circleStrokeWidth)
                        .foregroundColor(ColorManager.button)
                        .frame(width: constants.sendMessageCircleRadius, height: constants.sendMessageCircleRadius)
                })
        }
    }
}

struct ContactTutorial: View {
    @EnvironmentObject var sessionHandler: SessionHandler
    var body: some View {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        Text("Tap the icon in the top right to view contact scores and add contacts")
            .font(.footnote)
            .foregroundColor(ColorManager.darkGrey)
            .padding()
            .frame(maxWidth: screenWidth * 0.42)
            .background(ColorManager.lightGrey)
            .cornerRadius(5)
            .offset(x: screenWidth * 0.1, y: -screenHeight * 0.35)
            .onTapGesture {
                sessionHandler.activeTutorial = "chats"
            }
    }
}



struct ChatsTutorial: View {
    @EnvironmentObject var sessionHandler: SessionHandler
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        Text("Chats will appear in the center of the screen.  Tap to view details about them")
            .font(.footnote)
            .foregroundColor(ColorManager.darkGrey)
            .padding()
            .frame(maxWidth: screenWidth * 0.42)
            .background(ColorManager.lightGrey)
            .cornerRadius(5)
            .offset(x: 0, y: 0)
            .onTapGesture {
                sessionHandler.activeTutorial = "sendBop"
            }
    }
}

struct SendButtonTutorial: View {
    @EnvironmentObject var sessionHandler: SessionHandler
    @Binding var isShowingTutorial: Bool
    var body: some View {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        Text("Tap the button in the bottom right to select people to Bop")
            .font(.footnote)
            .foregroundColor(ColorManager.darkGrey)
            .padding()
            .frame(maxWidth: screenWidth * 0.42)
            .background(ColorManager.lightGrey)
            .cornerRadius(5)
            .offset(x: screenWidth * 0.1, y: screenHeight * 0.3)
            .onTapGesture {
                isShowingTutorial = false
            }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            DashboardView()
                .environmentObject(SessionHandler())
        }
    }
}
