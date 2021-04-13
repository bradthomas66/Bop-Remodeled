//
//  ChatBubbleView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-12.
//

import SwiftUI

struct ChatBubbleView: View {
    
    let chatToBubble: ChatBubbleData
    @EnvironmentObject var interactionHandler: DashboardInteractionHandler
    private let constants = Constants()
    
    private var zoomScale: CGFloat {
        get {
            let temp: CGFloat = min(
                interactionHandler.steadyStateZoomScale * pow((-interactionHandler.currentZoomScalar/interactionHandler.scrollOffset.y), 1.2),
                interactionHandler.smallestChatZoom)
            return temp
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ChatBoundingCircle()
                ChatContentStack(chatToBubble: chatToBubble)
            }
            .onTapGesture(count: 2, perform: {
                //interactionHandler.handleDoubleTap(chatToBubble)
            })
            .onTapGesture(count: 1, perform: {
                interactionHandler.handleBubbleTap(geometry: geometry, chatToBubble: chatToBubble)
            })
        }
        .frame(width: constants.maxCircleSize * chatToBubble.size * zoomScale, height: constants.maxCircleSize * chatToBubble.size * zoomScale, alignment: .center)
        .padding([.leading, .trailing])
    }
}

struct ChatBoundingCircle: View {
    
    private let constants = Constants()
    
    var body: some View {
        Circle()
            .stroke(lineWidth: constants.circleStrokeWidth)
            .foregroundColor(.white)
            .shadow(color: Color.white, radius: constants.circleShadowRadius)
    }
}

struct ChatContentStack: View {
    
    @EnvironmentObject var interactionHandler: DashboardInteractionHandler
    
    var chatToBubble: ChatBubbleData
    private let constants = Constants()
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text(chatToBubble.content).foregroundColor(ColorManager.whiteText)
                        .font(Font.system(size: min(geometry.size.height, geometry.size.width) * contentFontScale))
                    Text(chatToBubble.frequency.withCommas()).foregroundColor(ColorManager.whiteText)
                        .font(Font.system(size: min(geometry.size.height, geometry.size.width) * frequencyFontScale))
                    Spacer()
                }
                Spacer()
            }
        }
    }
    
    private let contentFontScale: CGFloat = 0.5
    private let frequencyFontScale: CGFloat = 0.2
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Rectangle().edgesIgnoringSafeArea(.all)
            ChatBubbleView(chatToBubble: ChatBubbleData(content: "🥵", frequency: 40, size: 0.5, id: 1))
                .environmentObject(DashboardInteractionHandler())
        }
        
    }
}
