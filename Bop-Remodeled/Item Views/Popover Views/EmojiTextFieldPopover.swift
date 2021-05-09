//
//  EmojiTextFieldPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-28.
//

import SwiftUI

struct EmojiTextFieldPopover: View {
    
    var parentViewHeight: CGFloat
    
    var body: some View {
        ZStack {
            OutsideRectangle()
            VStack {
                HStack {
                    Text("Send an Emoji")
                        .font(.title)
                        .foregroundColor(ColorManager.backgroundTopLeft)
                        .fontWeight(.bold)
                        .padding([.leading, .trailing], 45)
                        .padding(.top)
                    Spacer()
                }
                TextFieldBar(chatHandler: ChatHandler())
                    .padding(.top)
                Spacer()
            }
        }.frame(minHeight: parentViewHeight * 0.33, maxHeight: parentViewHeight * 0.33)
    }
}

struct TextFieldBar: View {
    
    @ObservedObject var chatHandler: ChatHandler
    
    @ObservedObject var interactionHandler = InteractionHandler()
    
    @State var emojiText: String = ""
    @State private var swipeOffset = CGSize.zero
    @State private var emojiTextFieldHasContents: Bool = false
    
    var isShowingSendBar: Bool
    {
        if emojiTextFieldHasContents {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                TextFieldWrapperView(emojiText: $emojiText, emojiTextFieldHasContents: $emojiTextFieldHasContents)
                Spacer()
            }
            HStack {
                Spacer()
                SwipeBar(height: 60)
                    .opacity(isShowingSendBar ? 1 : 0)
                    .offset(x: swipeOffset.width + 10)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if gesture.translation.width < 0 {
                                    swipeOffset.width = gesture.translation.width
                                    if swipeOffset.width < -75 && isShowingSendBar {
                                        swipeActivated()
                                    }
                                }
                            }
                            .onEnded { gesture in
                                swipeOffset = CGSize.zero
                            }
                    )
            }
        }.padding(.bottom, 45)
    }
    
    private func swipeActivated() {
        emojiTextFieldHasContents = false //instantly removes bar
        swipeOffset.width = 0
        chatHandler.sendMessage(emoji: emojiText)
    }
}

struct TextFieldWrapperView: View {
    
    @Binding var emojiText: String
    private let constants = Constants()
    
    @Binding var emojiTextFieldHasContents: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: constants.circleLineWidth)
                .foregroundColor(ColorManager.button)
                .frame(width: constants.circleWidth, height: constants.circleHeight)
            TextFieldWrapper(emojiText: $emojiText, fontSize: constants.emojiTextSize)
                .frame(width: constants.circleWidth, height: constants.circleHeight)
                .onChange(of: emojiText, perform: { value in
                    if value != "" {
                        emojiTextFieldHasContents = true
                    }
                })
        }
    }
}

struct EmojiTextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            EmojiTextFieldPopover(parentViewHeight: 460)
        }
    }
}
