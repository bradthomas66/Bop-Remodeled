//
//  BopMapView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-25.
//

import SwiftUI

struct BopMapView: View {
    
    @ObservedObject var userHandler: UserHandler = UserHandler()
    @EnvironmentObject var interactionHandler: BopMapInteractionHandler
    
    var body: some View {
        ZStack {
            Background()
            ContactBubbleScrollView(userHandler: userHandler)
        }
        .navigationTitle("Bop Map")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
        .navigationBarItems(trailing: Image(systemName: "person.crop.circle.badge.plus").foregroundColor(.white))
    }
}

struct ContactBubbleScrollView: View {
    
    @EnvironmentObject var interactionHandler: BopMapInteractionHandler
    @ObservedObject var userHandler: UserHandler
    
    @State private var contactsOnScreen: [ContactBubbleData] = []
    
    var body: some View {
        ScrollViewReader { action in
            ScrollView (
                axes: .vertical,
                showsIndicators: false,
                offsetChanged: {
                    interactionHandler.scrollOffset.y = $0.y - 1 //to ensure not divided by zero
                }
            ) {
                ZStack {
                    VStack {
                        ForEach (userHandler.parsedContactsSorted) { contact in
                            ContactBubbleView(contact: contact)
                                .onAppear(perform: {
                                    if contact.zoomScalar > 1.5 {
                                        interactionHandler.currentZoomScalar = contact.zoomScalar
                                    }
                                })
                        }
                    }.onAppear (perform: {
                        userHandler.parseContacts()
                        interactionHandler.zoomToSmallestContact(userHandler.parsedContactsSorted)
                    })
                }
            }
        }
    }
}




struct ContactSubview_Previews: PreviewProvider {
    static var previews: some View {
        BopMapView()
            .environmentObject(BopMapInteractionHandler())
    }
}
