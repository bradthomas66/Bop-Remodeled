//
//  RegisterPasswordPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-02-08.
//

import SwiftUI

struct RegisterPasswordPopover: View {
    
    var parentViewHeight: CGFloat
    
    @Binding var password: String
    @State var retypePassword: String = ""
    
    @Binding var passwordFieldHasContents: Bool
    
    private var passwordsMatch: Bool {
        if password == retypePassword {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Register Password")
                    .font(.title)
                    .foregroundColor(ColorManager.backgroundTopLeft)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            Divider().padding([.leading, .trailing])
            SecureField("Password", text: $password)
                .padding()
                .foregroundColor(ColorManager.darkGrey)
            SecureField("Retype Password", text: $retypePassword)
                .padding()
                .foregroundColor(ColorManager.darkGrey)
                .onChange(of: retypePassword, perform: { value in
                    if value != "" {
                        passwordFieldHasContents = true
                    }
                })
        }
        .frame(maxHeight: parentViewHeight * 0.3)
        .padding([.top, .bottom])
        .background(ColorManager.lightGrey)
        .cornerRadius(25.0)
    }
}

struct RegisterPasswordPopover_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            RegisterPasswordPopover(parentViewHeight: 640, password: .constant("test"), passwordFieldHasContents: .constant(true))
        }
    }
}
