//
//  LoginPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-21.
//

import SwiftUI

struct LoginPopover: View {
    
    var constants = Constants()
    
    var parentViewHeight: CGFloat
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var usernameFieldHasContents: Bool = false
    @State private var passwordFieldHasContents: Bool = false
    
    private var isShowingLoginButton: Bool {
        if usernameFieldHasContents && passwordFieldHasContents {
            return true
        }
        else { return false }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Login")
                    .font(.title)
                    .foregroundColor(ColorManager.backgroundTopLeft)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
                Button(action: {
                    if isShowingLoginButton {
                        print("logging in")
                    }
                }, label: {
                    LoginButtonView(capsuleWidth: constants.capsuleWidth, capsuleHeight: constants.capsuleHeight, isShowing: isShowingLoginButton)
                })
            }
            Divider().padding([.leading, .trailing])
            TextField("Username", text: $username)
                .padding()
                .onChange(of: username, perform: { value in
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
        .frame(minHeight: parentViewHeight * 0.33, maxHeight: parentViewHeight * 0.33)
        .padding([.top, .bottom])
        .background(ColorManager.lightGrey)
        .cornerRadius(25.0)
    }
}

struct LoginButtonView: View {
    
    var capsuleWidth: CGFloat
    var capsuleHeight: CGFloat
    var isShowing: Bool
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(ColorManager.button)
                .frame(width: capsuleWidth, height: capsuleHeight)
                .padding()
            HStack {
                Text("Login")
                    .foregroundColor(.white)
                    .font(.subheadline)
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundColor(.white)
            }
        }.opacity(isShowing ? 1 : 0)
        .padding(.trailing)
    }
}

struct LoginPopover_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            LoginPopover(parentViewHeight: 460)
        }
    }
}
