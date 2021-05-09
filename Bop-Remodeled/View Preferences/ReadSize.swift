//
//  ReadSize.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-04-13.
//
//  https://www.fivestars.blog/articles/swiftui-share-layout-information/

import Foundation
import SwiftUI

struct ReadSize: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
