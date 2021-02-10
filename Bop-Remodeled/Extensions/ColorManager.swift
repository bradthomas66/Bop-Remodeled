//
//  ColorManager.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-19.
//

import Foundation
import SwiftUI

struct ColorManager {
    static let backgroundTopLeft = Color("backgroundTopLeft")
    static let backgroundBottomRight = Color("backgroundBottomRight")
    static let button = Color("button")
    static let backgroundGradientColors = Gradient(colors: [ColorManager.backgroundTopLeft, ColorManager.backgroundBottomRight])
    static let lightGrey = Color("lightGrey")
    static let whiteText = Color(.white)
}
