//
//  OutsideRectangle.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-20.
//

import SwiftUI

struct OutsideRectangle: View {
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(ColorManager.lightGrey)
            .opacity(0.95)
            .edgesIgnoringSafeArea(.bottom)
    }
    private let cornerRadius: CGFloat = 25.0
}

struct OutsideRectangle_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            OutsideRectangle()
        }
    }
}
