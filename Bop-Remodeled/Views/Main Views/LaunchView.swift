//
//  LaunchView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-17.
//
// Let's Rock

import SwiftUI
import Combine

struct LaunchView: View {
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    
    @State private var loginHasBeenTapped: Bool = false //checks if the login button has ever been tapped in this instance
    @State private var isShowingLoginPopover: Bool = false //toggle that indicates if login popover is showing
    @State private var popoverOffset: CGFloat = 0
    
    private let constants = Constants()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                let offScreenOffset = screenHeight * 0.5 //offset to move popover offscreen
                
                ZStack {
                    Background()
                    
                    NavigationLink (
                        destination: RegistrationView(),
                        label: { GenericBubbleView(title: "Sign-up", subTitle: "", size: screenWidth * 0.55) }
                    ).offset(x: -screenWidth * 0.1, y: -screenHeight * 0.2)
                    
                    Button(action: {
                        isShowingLoginPopover = true
                        loginHasBeenTapped = true
                        popoverOffset = offScreenOffset //initialize popover offscreen
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.35, blendDuration: 1 )) {
                            popoverOffset = 0.0
                        }
                    }, label: {
                        GenericBubbleView(title: "Login", subTitle: "", size: screenWidth * 0.35)
                    }).offset(x: screenWidth * 0.2, y: screenHeight * 0.25)
                    
                    if isShowingLoginPopover {
                        Rectangle()
                            .foregroundColor(.white)
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.01)
                            .onTapGesture(perform: {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.35, blendDuration: 1 )) {
                                    popoverOffset = offScreenOffset
                                }
                                isShowingLoginPopover = false
                            })
                    }
                    VStack {
                        Spacer()
                        if !loginHasBeenTapped { // if user hasnt touched the login button yet, present popover offscreen
                            LoginPopover(parentViewHeight: screenHeight)
                                .offset(y: offScreenOffset)
                        } else {
                            LoginPopover(parentViewHeight: screenHeight)
                                .offset(y: popoverOffset)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("Bop")
            .navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
