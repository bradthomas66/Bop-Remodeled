//
//  Background.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-19.
//

import SwiftUI

struct Background: View {
    
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(LinearGradient(gradient: ColorManager.backgroundGradientColors, startPoint: .top, endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea(.all)
    }
}


struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}
