//
//  RegisterEmojiBubbleView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-07-08.
//

import SwiftUI

struct RegisterEmojiBubbleView: View {
    
    var title: String
    var subTitle: String
    var subTitleHasContents: Bool {
        if subTitle != "" {
            return true
        } else {
            return false
        }
    }
    
    var titleScale: CGFloat = 0.2
    
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
                        .font(Font.system(size: size * titleScale * 1.75))
                }
            }
            
        }.frame(width: size, height: size, alignment: .center)
    }
}

struct RegisterEmojiBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            RegisterEmojiBubbleView(title: "Name", subTitle: "☔️", size: 240)
        }
    }
}
