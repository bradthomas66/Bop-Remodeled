//
//  RegisterNamePopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-27.
//

import SwiftUI

struct RegisterNamePopover: View {
    
    var parentViewHeight: CGFloat
    
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var fullName: String
    
    @Binding var firstNameFieldHasContents: Bool
    @Binding var lastNameFieldHasContents: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Register Name")
                    .font(.title)
                    .foregroundColor(ColorManager.backgroundTopLeft)
                    .fontWeight(.bold)
                    .padding()
                Spacer()
            }
            Divider().padding([.leading, .trailing])
            TextField("First Name", text: $firstName)
                .padding()
                .onChange(of: firstName, perform: { value in
                    if value != "" {
                        firstNameFieldHasContents = true
                    }
                })
            TextField("Last Name", text: $lastName)
                .padding()
                .onChange(of: lastName, perform: { value in
                    if value != "" {
                        lastNameFieldHasContents = true
                    }
                })
        }
        .frame(minHeight: parentViewHeight * 0.33, maxHeight: parentViewHeight * 0.4)
        .padding([.top, .bottom])
        .background(ColorManager.lightGrey)
        .cornerRadius(25.0)
        .onAppear(perform: {
            if firstName != "" && lastName != "" {
                fullName = firstName + " " + lastName
            } else {
                print(firstName)
                fullName = ""
            }
        })
    }
}

struct RegisterNamePopoverView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            RegisterNamePopover(parentViewHeight: 460, firstName: .constant("Brad"), lastName: .constant("Thomas"), fullName: .constant(""), firstNameFieldHasContents: .constant(false), lastNameFieldHasContents: .constant(true))
        }
    }
}
