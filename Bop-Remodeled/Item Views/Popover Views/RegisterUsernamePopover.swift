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
    @Binding var usernameFieldHasContents: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Register Username")
                        .font(.title)
                        .foregroundColor(ColorManager.backgroundTopLeft)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }
                Divider().padding([.leading, .trailing])
                TextField("Username", text: $username)
                    .padding()
                    .foregroundColor(ColorManager.darkGrey)
                    .onChange(of: username, perform: { value in
                        if value != "" {
                            usernameFieldHasContents = true
                        }
                    })
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
            RegisterUsernamePopover(parentViewHeight: 460, username: .constant("Coolguy"), usernameFieldHasContents: .constant(true))
        }
    }
}
