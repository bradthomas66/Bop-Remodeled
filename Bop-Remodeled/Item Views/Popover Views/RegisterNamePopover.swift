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
    
    var fullName: String {
        firstName + " " + lastName
    }
    
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
                .foregroundColor(ColorManager.darkGrey)
                .onChange(of: firstName, perform: { value in
                    if value != "" {
                        firstNameFieldHasContents = true
                    }
                })
            TextField("Last Name", text: $lastName)
                .padding()
                .foregroundColor(ColorManager.darkGrey)
                .onChange(of: lastName, perform: { value in
                    if value != "" {
                        lastNameFieldHasContents = true
                    }
                })
        }
        .frame(maxHeight: parentViewHeight * 0.3)
        .padding([.top, .bottom])
        .background(ColorManager.lightGrey)
        .cornerRadius(25.0)
    }
}

struct RegisterNamePopoverView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            RegisterNamePopover(parentViewHeight: 640, firstName: .constant("Brad"), lastName: .constant("Thomas"), firstNameFieldHasContents: .constant(false), lastNameFieldHasContents: .constant(true))
        }
    }
}
