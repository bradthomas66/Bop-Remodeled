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
    
    var body: some View {
        VStack {
            HStack {
                Text("Register Name")
                    .font(.title)
                    .foregroundColor(ColorManager.backgroundTopLeft)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                Spacer()
            }
            Divider().padding([.leading, .trailing])
            TextField("First Name", text: $firstName)
                .padding()
            TextField("Last Name", text: $lastName)
                .padding()
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
            RegisterNamePopover(parentViewHeight: 460, firstName: .constant("Brad"), lastName: .constant("Thomas"), fullName: .constant(""))
        }
    }
}
