//
//  BopMapInteractionHandler.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-03-09.
//

import Foundation
import SwiftUI

class BopMapInteractionHandler: ObservableObject {

    @Published var activeContact: Contact? = nil
    @Published var activeCoordinate: CGPoint? = nil
    @Published var contactPopoverOffset: CGFloat = 640 //fix this!!

    @Published var steadyStateZoomScale: CGFloat = 1.0
    @Published var dynamicZoomScale: CGFloat = 1.0

    @Published var scrollOffset: CGPoint = CGPoint(x: 1.0, y: -1.0)
    
    @Published var currentZoomScalar: CGFloat = 1.0  //zoom scalar from bubble size 
    
    @Published var smallestContactZoom: CGFloat = 1
    @Published var minSize: CGFloat = 1

//    func handleContactTap(geometry: GeometryProxy, chatToBubble: ChatBubbleData) {
//        isShowingPopover = true
//        anyParentHasBeenTapped = true
//        activeCoordinate = CGPoint(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
//        activeChat = ChatBubbleData(content: chatToBubble.content, frequency: chatToBubble.frequency, size: chatToBubble.size, id: chatToBubble.id)
//        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 10)) {
//            chatPopoverOffset = 0
//        }
//    }

    func zoomToSmallestContact(_ data: [ContactBubbleData]) {
        
        var minSize: CGFloat = 1.0

        for row in data {
            if row.size < minSize {
                minSize = row.size
            }
        }
        
        smallestContactZoom = 0.8 / minSize //variable to store the value without manipulation by dynamicZoomScale
        steadyStateZoomScale = 0.8 / minSize //inverse of chat.size; ex: chat.size = 0.5, steadyStateZoomScale = 2 -> chat.size * steadyStateZoomScale = 1
        self.minSize = minSize
        print(steadyStateZoomScale)
    }

}
