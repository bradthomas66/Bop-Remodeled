//
//  RegisterEmojiPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-06-25.
//

import SwiftUI

struct RegisterEmojiPopover: View {

    var parentViewHeight: CGFloat
    @Binding var emojiText: String
    @Binding var emojiFieldHasContents: Bool
    
    let constants = Constants()

    var body: some View {
        ZStack {
            OutsideRectangle()
            VStack {
                HStack {
                    Text("Pick a Profile Emoji")
                        .font(.title)
                        .foregroundColor(ColorManager.backgroundTopLeft)
                        .fontWeight(.bold)
                        .padding([.leading, .trailing], 45)
                        .padding(.top)
                    Spacer()
                }
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(lineWidth: constants.circleLineWidth)
                            .foregroundColor(ColorManager.button)
                            .frame(width: constants.circleWidth, height: constants.circleHeight)
                        TextFieldWrapper(emojiText: $emojiText, fontSize: constants.emojiTextSize)
                            .frame(width: constants.circleWidth, height: constants.circleHeight)
                            .foregroundColor(ColorManager.darkGrey)
                            .onChange(of: emojiText, perform: { emoji in
                                if emoji != "" {
                                    emojiFieldHasContents = true
                                }
                            })
                        
                    }
                    Spacer()
                }
                Spacer()
            }
        }.frame(maxHeight: parentViewHeight * 0.3)
    }
}


struct RegisterEmojiPopover_Previews: PreviewProvider {
    static var previews: some View {
        RegisterEmojiPopover(parentViewHeight: 640, emojiText: .constant("🌼"), emojiFieldHasContents: .constant(true))
    }
}
