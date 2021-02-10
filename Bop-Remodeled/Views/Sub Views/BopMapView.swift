//
//  BopMapView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-25.
//

import SwiftUI

struct BopMapView: View {
    
    @ObservedObject var userHandler: UserHandler = UserHandler()
    
    var body: some View {
        ZStack {
            Background()
            ContactBubbleScrollView(userHandler: userHandler)
        }.onAppear(perform: {userHandler.parseContacts()})
        .navigationTitle("Bop Map").navigationBarTitleDisplayMode(.inline).navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
        .navigationBarItems(trailing: Image(systemName: "person.crop.circle.badge.plus").foregroundColor(.white))
    }
}

struct ContactSubview_Previews: PreviewProvider {
    static var previews: some View {
        BopMapView()
    }
}

struct ContactBubbleScrollView: View {
    @ObservedObject var userHandler: UserHandler
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach (userHandler.parsedContactsSorted) { contact in
                    ContactBubbleView(contact: contact)
                }
            }
        }
    }
}
