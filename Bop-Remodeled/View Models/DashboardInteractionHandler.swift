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
    
    @Published var activeChat: ChatBubbleData? = nil
    @Published var activeCoordinate: CGPoint? = nil
    @Published var chatPopoverOffset: CGFloat = 640
    
    @Published var isShowingPopover: Bool = false
    @Published var anyParentHasBeenTapped: Bool = false
    
    func handleBubbleTap(geometry: GeometryProxy, chatToBubble: ChatBubbleData) {
        isShowingPopover = true
        anyParentHasBeenTapped = true
        activeCoordinate = CGPoint(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
        activeChat = ChatBubbleData(content: chatToBubble.content, frequency: chatToBubble.frequency, size: chatToBubble.size, id: chatToBubble.id)
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 10)) {
            chatPopoverOffset = 0
        }
    }
    
    func handleBackgroundTap(geometry: GeometryProxy, offScreenOffset: CGFloat) {
        
        withAnimation(.linear(duration: 0.1)) {
            chatPopoverOffset = offScreenOffset
        }
        
        isShowingPopover = false
    }
    
}
