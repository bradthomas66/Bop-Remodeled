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
    
    var body: some View {
        VStack {
            HStack {
                Text("Register Password")
                    .font(.title)
                    .foregroundColor(ColorManager.backgroundTopLeft)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                Spacer()
            }
            Divider().padding([.leading, .trailing])
            SecureField("Password", text: $password)
                .padding()
            SecureField("Retype Password", text: $retypePassword)
                .padding()
        }
        .frame(minHeight: parentViewHeight * 0.33, maxHeight: parentViewHeight * 0.4)
        .padding([.top, .bottom])
        .background(ColorManager.lightGrey)
        .cornerRadius(25.0)
    }
}

struct RegisterPasswordPopover_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            RegisterPasswordPopover(parentViewHeight: 460, password: .constant("test"))
        }
    }
}
