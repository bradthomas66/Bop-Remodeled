//
//  SwipeBar.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-02-21.
//

import SwiftUI

struct SwipeBar: View {
    
    let height: CGFloat
    let width: CGFloat = 50
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: width, height: height, alignment: .center)
                .foregroundColor(ColorManager.darkGrey)
                .cornerRadius(10)
            HStack {
                Image(systemName: "arrowtriangle.left.fill")
                    .foregroundColor(.white)
                    .padding(5)
                Spacer()
            }.frame(width: width, height: height, alignment: .center)
        }
    }
}

struct SwipeBar_Previews: PreviewProvider {
    static var previews: some View {
        SwipeBar(height: 100)
    }
}
