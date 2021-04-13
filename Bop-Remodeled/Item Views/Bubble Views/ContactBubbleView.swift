//
//  ContactBubbleView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-25.
//

import SwiftUI

struct ContactBubbleView: View {
    
    var contact: ContactBubbleData
    @EnvironmentObject var interactionHandler: BopMapInteractionHandler
    private let constants = Constants()
    
    private var zoomScale: CGFloat {
        get {
            let temp: CGFloat = min(
                interactionHandler.steadyStateZoomScale * pow((-interactionHandler.currentZoomScalar/interactionHandler.scrollOffset.y), 2.0),
                interactionHandler.smallestContactZoom)
            return temp
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ContactBoundingCircle()
                ContactContentStack(contact: contact)
            }
        }
        .frame(width: constants.maxCircleSize * contact.size * zoomScale, height: constants.maxCircleSize * contact.size * zoomScale, alignment: .center)
        .padding([.leading, .trailing])
    }
}

struct ContactBoundingCircle: View {
    
    private var constants = Constants()
    
    var body: some View {
        Circle()
            .stroke(lineWidth: constants.circleStrokeWidth)
            .foregroundColor(.white)
            .shadow(color: ColorManager.whiteText, radius: constants.circleShadowRadius)
    }
}

struct ContactContentStack: View {
    var contact: ContactBubbleData
    private var scoreWithCommas: String
    private let constants = Constants()
    
    init (contact: ContactBubbleData) {
        self.scoreWithCommas = contact.score.withCommas()
        self.contact = contact
    }
    
    @EnvironmentObject var interactionHandler: BopMapInteractionHandler
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text(contact.emoji).foregroundColor(ColorManager.whiteText)
                        .font(Font.system(size: min(geometry.size.height, geometry.size.width) * emojiFontScale))
                    Text(scoreWithCommas).foregroundColor(ColorManager.whiteText)
                        .font(Font.system(size: min(geometry.size.height, geometry.size.width) * scoreFontScale))
                    Text(contact.name).foregroundColor(ColorManager.whiteText)
                        .font(Font.system(size: min(geometry.size.height, geometry.size.width) * nameFontScale))
                    Spacer()
                }
                Spacer()
            }
        }
    }
    private let emojiFontScale: CGFloat = 0.55
    private let scoreFontScale: CGFloat = 0.12
    private let nameFontScale: CGFloat = 0.07
}

struct ContactBubble_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Rectangle().edgesIgnoringSafeArea(.all)
            ContactBubbleView(contact: ContactBubbleData(emoji: "👽", name: "Brad Thomas", score: 4000000, size: 1))
                .environmentObject(BopMapInteractionHandler())
        }
        
    }
}
