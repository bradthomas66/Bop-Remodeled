//
//  ScoresView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-25.
//

import SwiftUI

struct ScoresView: View {
    
    @ObservedObject var userHandler: UserHandler = UserHandler()
    @EnvironmentObject var interactionHandler: InteractionHandler
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Background()
                ContactBarScrollView(userHandler: userHandler, geometry: geometry)
            }
            .navigationTitle("Scores")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(UIColor(ColorManager.backgroundTopLeft))
            .navigationBarItems(trailing: Image(systemName: "person.crop.circle.badge.plus").foregroundColor(.white))
        }
    }
}

struct ContactBarScrollView: View {
    
    @EnvironmentObject var interactionHandler: InteractionHandler
    @ObservedObject var userHandler: UserHandler
    let constants = Constants()
    
    let geometry: GeometryProxy
    
    var body: some View {
        ScrollViewReader { action in
            ScrollView () {
                VStack (spacing: 0) {
                    ForEach (userHandler.parsedContactsSorted) { contact in
                        ContactBarView(contactToBar: contact, width: geometry.size.width, height: geometry.size.height * constants.barViewGlobalBarHeight)
                            .padding(.vertical, constants.barViewGlobalPadding)
                    }
                }.onAppear (perform: {
                    userHandler.parseContacts()
                })
            }
        }
    }
}




struct ContactSubview_Previews: PreviewProvider {
    static var previews: some View {
        ScoresView()
            .environmentObject(InteractionHandler())
    }
}
