//
//  ContactBubbleView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-25.
//

import SwiftUI

struct ContactBubbleView: View {
    
    var contact: ContactBubbleData
    
    init (contact: ContactBubbleData) {
        self.contact = contact
    }
    
    var body: some View {
        ZStack {
            ContactBoundingCircle()
                .frame(width: maxCircleSize * contact.size, height: maxCircleSize * contact.size)
            ContactContentStack(contact: contact, maxCircleSize: maxCircleSize)
                .frame(width: maxCircleSize * contact.size, height: maxCircleSize * contact.size)
        }
    }
    private let maxCircleSize: CGFloat = 300
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
    let maxCircleSize: CGFloat
    
    init (contact: ContactBubbleData, maxCircleSize: CGFloat) {
        self.scoreWithCommas = contact.score.withCommas()
        self.contact = contact
        self.maxCircleSize = maxCircleSize
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
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
        }
        
    }
}