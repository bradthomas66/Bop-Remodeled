//
//  BackgroundRectangle.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-05-28.
//

import SwiftUI

struct BackgroundRectangle: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    let screenHeight: CGFloat
    
    var body: some View {
        Rectangle()
            .foregroundColor(.white)
            .edgesIgnoringSafeArea(.top)
            .opacity(0.01)
            .onTapGesture(perform: {
                sessionHandler.handleBackgroundTap(offScreenOffset: screenHeight)
            })
    }
}
