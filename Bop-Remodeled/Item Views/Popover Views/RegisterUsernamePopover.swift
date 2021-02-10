//
//  RegisterUsernamePopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-02-08.
//

import SwiftUI

struct RegisterUsernamePopover: View {
    
    var parentViewHeight: CGFloat
    
    @Binding var username: String
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Register Username")
                        .font(.title)
                        .foregroundColor(ColorManager.backgroundTopLeft)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                    Spacer()
                }
                Divider().padding([.leading, .trailing])
                TextField("Username", text: $username)
                    .padding()
            }
            .frame(minHeight: parentViewHeight * 0.2, maxHeight: parentViewHeight * 0.25)
            .padding([.top, .bottom])
            .background(ColorManager.lightGrey)
            .cornerRadius(25.0)
        }
    }
}

struct RegisterUsernamePopover_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            RegisterUsernamePopover(parentViewHeight: 460, username: .constant("Coolguy"))
        }
    }
}
