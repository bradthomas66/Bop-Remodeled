//
//  OpacityAnimationModifier.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-07-25.
//
// https://swiftui.diegolavalle.com/posts/animation-ended/

import Foundation
import SwiftUI

struct OpacityAnimationModifier: AnimatableModifier {
    
    var totalOpacityChange: CGFloat
    var percentage: CGFloat
    var onCompletion: () -> () = {}
    
    private var opacity: CGFloat {
        totalOpacityChange * percentage
    }
    
    var animatableData: CGFloat {
        get { percentage }
        set {
          percentage = newValue
          checkIfFinished()
        }
      }
    
    func checkIfFinished () -> () {
        if percentage == 1 {
            DispatchQueue.main.async {
                self.onCompletion()
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
            .opacity(Double(opacity))
    }
}
