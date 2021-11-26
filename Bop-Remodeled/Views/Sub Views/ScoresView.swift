//
//  ScoresView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-25.

// https://stackoverflow.com/questions/56571349/custom-back-button-for-navigationviews-navigation-bar-in-swiftui
//

import SwiftUI

struct ScoresView: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    
    var body: some View {
        GeometryReader { geometry in
            
            let screenHeight = UIScreen.main.bounds.height
            let screenWidth = UIScreen.main.bounds.width
            
            let thereIsAPendingContact: Bool = isTherePendingContacts()
        
            ZStack {
                Background()
                ContactBarScrollView()
                if sessionHandler.isShowingPopover {
                    BackgroundRectangle(screenHeight: screenHeight)
                }
                VStack {
                    Spacer()
                    AddContactPopover(parentViewHeight: geometry.size.height, parentViewWidth: geometry.size.width)
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
                    
                }.ignoresSafeArea(.container)
                
                if authenticationHandler.firstTimeLogin {
                    Rectangle()
                        .foregroundColor(.black)
                        .edgesIgnoringSafeArea(.all)
                        .opacity(0.3)
                        .blur(radius: 20)
                        .onTapGesture {
                            switch sessionHandler.activeTutorial {
                            case "addContact": sessionHandler.activeTutorial = "scores"
                            case "scores": sessionHandler.activeTutorial = "scoresBack"
                            default: authenticationHandler.turnOffFirstTimeLogin()
                            }
                        }
                    
                    switch sessionHandler.activeTutorial {
                    case "addContact":AddContactTutorial()
                    case "scores": ScoresTutorial()
                    case "scoresBack": ScoresBackTutorial()
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
            }
            .navigationTitle("Scores")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
            .navigationBarItems(
                leading: Button (action: {
                    self.presentationMode.wrappedValue.dismiss()
                    if sessionHandler.activeTutorial == "scoresBack" {
                        sessionHandler.hasSeenScoresTutorial = true
                        sessionHandler.activeTutorial = "sendButton"
                    }
                }, label: {
                    BackButtonView()
                }),
                trailing:
                    Image(systemName: "person.crop.circle.badge.plus").foregroundColor(thereIsAPendingContact ? ColorManager.button : .white)
                    .onTapGesture {
                        sessionHandler.handleOtherParentTap()
                    }
            ).navigationBarBackButtonHidden(true)
            .onAppear() {
                sessionHandler.popoverOffset = screenHeight
                sessionHandler.isShowingPopover = false
                sessionHandler.getContacts()
            }
        }
    }
    
    func isTherePendingContacts() -> Bool {
        for contact in sessionHandler.myContacts {
            if contact.pending == true {
                return true
            }
        }
        return false
    }
}

struct ContactBarScrollView: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    private let constants = Constants()
    
    private let height = UIScreen.main.bounds.height
    private let width = UIScreen.main.bounds.width
    
    var body: some View {
        ScrollViewReader { action in
            ScrollView() {
                VStack (spacing: 0) {
                    ForEach (sessionHandler.parsedContactsSorted) { contact in
                        ContactBarView(contactToBar: contact, width: width * constants.barViewGlobalBarWidth, height: height * constants.barViewGlobalBarHeight)
                            .padding(.vertical, constants.barViewGlobalPadding)
                    }
                }
            }
        }
    }
}


struct AddContactTutorial: View {
    @EnvironmentObject var sessionHandler: SessionHandler
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        Text("Tap the icon in the top right to add contacts")
            .font(.footnote)
            .foregroundColor(ColorManager.darkGrey)
            .padding()
            .frame(maxWidth: screenWidth * 0.42)
            .background(ColorManager.lightGrey)
            .cornerRadius(5)
            .offset(x: screenWidth * 0.1, y: -screenHeight * 0.35)
            .onTapGesture {
                sessionHandler.activeTutorial = "scores"
            }
    }
}

struct ScoresTutorial: View {
    @EnvironmentObject var sessionHandler: SessionHandler
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        Text("Contact's scores will appear in the center of the screen.")
            .font(.footnote)
            .foregroundColor(ColorManager.darkGrey)
            .padding()
            .frame(maxWidth: screenWidth * 0.42)
            .background(ColorManager.lightGrey)
            .cornerRadius(5)
            .offset(x: 0, y: 0)
            .onTapGesture {
                sessionHandler.activeTutorial = "scoresBack"
            }
    }
}

struct ScoresBackTutorial: View {
    @EnvironmentObject var sessionHandler: SessionHandler
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        Text("Press back to go back to the Dashboard")
            .font(.footnote)
            .foregroundColor(ColorManager.darkGrey)
            .padding()
            .frame(maxWidth: screenWidth * 0.42)
            .background(ColorManager.lightGrey)
            .cornerRadius(5)
            .offset(x: -screenWidth * 0.1, y: -screenHeight * 0.35)
            .onTapGesture {
                sessionHandler.activeTutorial = "sendBop"
            }
    }
}

struct BackButtonView: View {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        HStack {
            Image("WhiteArrow")
                .resizable()
                .frame(width: screenWidth * 0.075, height: screenHeight * 0.035)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            Text("Back")
                .foregroundColor(ColorManager.lightGrey)
                .font(.subheadline)
        }
    }
}

struct ContactSubview_Previews: PreviewProvider {
    static var previews: some View {
        ScoresView()
            .environmentObject(SessionHandler())
    }
}
