//
//  View+navigationBarColor.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-25.
//

import Foundation
import SwiftUI

extension View {
    func navigationBarColor(_ backgroundColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor))
    }
}
