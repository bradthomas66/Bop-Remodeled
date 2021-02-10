//
//  RegisterEmailPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-28.
//

import SwiftUI

struct RegisterEmailPopover: View {
    
    var parentViewHeight: CGFloat
    
    @Binding var email: String
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Register Email")
                        .font(.title)
                        .foregroundColor(ColorManager.backgroundTopLeft)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                    Spacer()
                }
                Divider().padding([.leading, .trailing])
                TextField("Email", text: $email)
                    .padding()
            }
            .frame(minHeight: parentViewHeight * 0.2, maxHeight: parentViewHeight * 0.25)
            .padding([.top, .bottom])
            .background(ColorManager.lightGrey)
            .cornerRadius(25.0)
        }
    }
}

struct RegisterEmailPopover_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            RegisterEmailPopover(parentViewHeight: 460, email: .constant("bradley-thomas1@hotmail.com"))
        }
    }
}
