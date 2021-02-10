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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ChatBoundingCircle()
                ChatContentStack(chatToBubble: chatToBubble)
            }.onTapGesture(perform: {
                interactionHandler.handleBubbleTap(geometry: geometry, chatToBubble: chatToBubble)
            })
        }.frame(width: constants.maxCircleSize * chatToBubble.size, height: constants.maxCircleSize * chatToBubble.size, alignment: .center)
        .padding([.leading, .trailing])
    }
    
    private let maxCircleSize: CGFloat = 300
    private let circlePaddingSize: CGFloat = 5
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
    var chatToBubble: ChatBubbleData
    private let constants = Constants()
    
    var body: some View {
        VStack {
            Text(chatToBubble.content).foregroundColor(ColorManager.whiteText)
                .font(Font.system(size: constants.maxCircleSize * chatToBubble.size * contentFontScale))
            Text(chatToBubble.frequency.withCommas()).foregroundColor(ColorManager.whiteText)
                .font(Font.system(size: constants.maxCircleSize * chatToBubble.size * frequencyFontScale))
        }
    }
    
    private let contentFontScale: CGFloat = 0.6
    private let frequencyFontScale: CGFloat = 0.2
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Rectangle().edgesIgnoringSafeArea(.all)
            ChatBubbleView(chatToBubble: ChatBubbleData(content: "🥵", frequency: 40, size: 0.5, id: 1))
        }
        
    }
}
