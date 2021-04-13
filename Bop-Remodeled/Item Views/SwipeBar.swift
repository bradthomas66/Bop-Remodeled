//
//  SwipeBar.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-02-21.
//

import SwiftUI

struct SwipeBar: View {
    
    let height: CGFloat
    let width: CGFloat
    
    var body: some View {
        Capsule()
            .frame(width: width, height: height, alignment: .center)
            .foregroundColor(ColorManager.darkGrey)
            .padding(.horizontal, 30)
    }
    
}

struct SwipeBar_Previews: PreviewProvider {
    static var previews: some View {
        SwipeBar(height: 100, width: 3)
    }
}
