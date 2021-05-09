//
//  View+ReadSize.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-04-13.
//
//  https://www.fivestars.blog/articles/swiftui-share-layout-information/

import Foundation
import SwiftUI

extension View {
    func readSize (onChange: @escaping (CGSize) -> Void) -> some View {
        background (
            GeometryReader { geometry in
                Color.clear
                    .preference(key: ReadSize.self, value: geometry.size)
            }
        ).onPreferenceChange(ReadSize.self, perform: onChange)
    }
}
