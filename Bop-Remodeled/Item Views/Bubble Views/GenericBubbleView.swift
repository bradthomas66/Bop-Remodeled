//
//  GenericBubbleView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-01-17.
//

import SwiftUI

struct GenericBubbleView: View {
    
    var title: String
    var subTitle: String
    var subTitleHasContents: Bool {
        if subTitle != "" {
            return true
        } else {
            return false
        }
    }
    
    var titleScale: CGFloat {
        if size < 150 {
            return 0.2
        }
        else {
            return 0.15
        }
    }
    
    var size: CGFloat
    private let constants = Constants()
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: constants.circleStrokeWidth)
                .foregroundColor(.white)
                .shadow(color: ColorManager.whiteText, radius: constants.circleShadowRadius)
            VStack {
                Text(title).foregroundColor(ColorManager.whiteText)
                    .font(Font.system(size: size * titleScale))
                if subTitleHasContents {
                    Text(subTitle).foregroundColor(ColorManager.whiteText)
                        .font(Font.system(size: size * titleScale*0.45))
                }
            }
            
        }.frame(width: size, height: size, alignment: .center)
    }
}

struct GenericBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            GenericBubbleView(title: "Name", subTitle: "☔️", size: 240)
        }
    }
}
