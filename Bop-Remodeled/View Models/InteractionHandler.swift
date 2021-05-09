//
//  InteractionHandler.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-06.
//

import Foundation
import SwiftUI

class InteractionHandler: ObservableObject {
    @ObservedObject var chatHandler = ChatHandler()
    
    //chat that is selected by user tap
    @Published var activeChat: ChatBarData? = nil
    @Published var activeCoordinate: CGPoint? = nil //coordinate of user tap
    
    @Published var popoverOffset: CGFloat = 640 //offset that sets popovers off screen - Fix this!
    
    @Published var isShowingPopover: Bool = false //boolean for popover display status
    @Published var anyParentHasBeenTapped: Bool = false //boolean for if a bubble is tapped
    
    @Published var scrollOffset: CGPoint = CGPoint(x: 1.0, y: -1.0) //coordinate set that tracks scroll position
    
    //Actions resulting from a single tap of the chat bubble
    func handleBarTap(geometry: GeometryProxy, chatToBubble: ChatBarData) {
        isShowingPopover = true
        anyParentHasBeenTapped = true
        activeCoordinate = CGPoint(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
        activeChat = ChatBarData(emoji: chatToBubble.emoji, score: chatToBubble.score, size: chatToBubble.size, id: chatToBubble.id)
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 10)) {
            popoverOffset = 0
        }
    }
    
    //Actions resulting from screen taps behind the popover
    func handleBackgroundTap(geometry: GeometryProxy, offScreenOffset: CGFloat) {
        withAnimation(.linear(duration: 0.1)) {
            popoverOffset = offScreenOffset
        }
        isShowingPopover = false
    }
}
