//
//  DashboardInteractionHandler.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-06.
//

import Foundation
import SwiftUI

class DashboardInteractionHandler: ObservableObject {
    @ObservedObject var chatHandler = ChatHandler()
    
    @Published var activeChat: ChatBubbleData? = nil //chat that is selected by user tap
    @Published var activeCoordinate: CGPoint? = nil //coordinate of user tap
    @Published var chatPopoverOffset: CGFloat = 640 //offset that sets popovers off screen - Fix this!
    
    @Published var isShowingPopover: Bool = false //boolean for popover display status
    @Published var anyParentHasBeenTapped: Bool = false //boolean for if a bubble is tapped
    
    @Published var steadyStateZoomScale: CGFloat = 1.0 //static zoomscale scalar from position on screen and user interaction
    //@Published var dynamicZoomScale: CGFloat = 1.0 //dynamic zoomscale scalar from user gesture (ie. pinch)
    
    @Published var scrollOffset: CGPoint = CGPoint(x: 1.0, y: -1.0) //coordinate set that tracks scroll position
    
    @Published var currentZoomScalar: CGFloat = 1.0
    
    @Published var smallestChatZoom: CGFloat = 1 //zoom level required for the smallest chat
    
    //Actions resulting from a single tap of the chat bubble
    func handleBubbleTap(geometry: GeometryProxy, chatToBubble: ChatBubbleData) {
        isShowingPopover = true
        anyParentHasBeenTapped = true
        activeCoordinate = CGPoint(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
        activeChat = ChatBubbleData(content: chatToBubble.content, frequency: chatToBubble.frequency, size: chatToBubble.size, id: chatToBubble.id)
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 10)) {
            chatPopoverOffset = 0
        }
    }
    
    //Actions resulting from a double tap of the chat bubble
//    func handleDoubleTap (_ chat: ChatBubbleData) {
//        steadyStateZoomScale = 1 / chat.size
//        activeChat = ChatBubbleData(content: chat.content, frequency: chat.frequency, size: chat.size, id: chat.id)
//    }
    
    //Find the zoom level required for the smallest chat to take 80% of the screen width and zoom to it
    func zoomToSmallestChat(_ data: [ChatBubbleData]) {
        var minSize: CGFloat = 1.0
        
        for row in data {
            if row.size < minSize {
                minSize = row.size
            }
        }
        
        smallestChatZoom = 0.8 / minSize //stores initial zoom value
        steadyStateZoomScale = 0.8 / minSize //sets steady state zoomScale
    }
    
    //Actions resulting from screen taps behind the popover
    func handleBackgroundTap(geometry: GeometryProxy, offScreenOffset: CGFloat) {
        
        withAnimation(.linear(duration: 0.1)) {
            chatPopoverOffset = offScreenOffset
        }
        
        isShowingPopover = false
    }
    
}
