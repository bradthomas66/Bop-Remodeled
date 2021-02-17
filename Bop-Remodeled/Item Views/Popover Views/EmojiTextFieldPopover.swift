//
//  EmojiTextFieldPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-28.
//

import SwiftUI

struct EmojiTextFieldPopover: View {
    
    var parentViewHeight: CGFloat
    
    @ObservedObject var userHandler = UserHandler()
    @State var emojiText: String = ""
    
    var body: some View {
        ZStack {
            OutsideRectangle()
            VStack {
                HStack {
                    Text("Send an Emoji")
                        .font(.title)
                        .foregroundColor(ColorManager.backgroundTopLeft)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding([.leading, .trailing], 45)
                        .padding(.top)
                    Spacer()
                }
                TextFieldBar(emojiText: $emojiText)
                    .padding(.top)
                Spacer()
            }
        }.frame(minHeight: parentViewHeight * 0.33, maxHeight: parentViewHeight * 0.33)
    }
}

struct TextFieldBar: View {
    
    @Binding var emojiText: String
    
    var body: some View {
        HStack {
            ButtonSpacer(capsuleWidth: capsuleWidth, capsuleHeight: capsuleHeight)
            Spacer()
            TextFieldWrapperView(emojiText: $emojiText)
            Spacer()
            Button(action: {print ("send message")}, label: {
                SendButton(capsuleWidth: capsuleWidth, capsuleHeight: capsuleHeight)
            })
        }
    }
    private let capsuleWidth: CGFloat = 50
    private let capsuleHeight: CGFloat = 30
}

struct TextFieldWrapperView: View {
    
    @Binding var emojiText: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: circleLineWidth)
                .foregroundColor(ColorManager.button)
                .frame(width: circleWidth, height: circleHeight)
            TextFieldWrapper(emojiText: $emojiText, fontSize: emojiTextSize)
                .frame(width: circleWidth, height: circleHeight)
        }
    }
    private let emojiTextSize: CGFloat = 30
    private let circleWidth: CGFloat = 50
    private let circleHeight: CGFloat = 50
    private let circleLineWidth: CGFloat = 2
}

struct BackgroundColor: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .foregroundColor(.clear)
            .background(ColorManager.backgroundTopLeft)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ButtonSpacer: View {
    
    let capsuleWidth: CGFloat
    let capsuleHeight: CGFloat
    
    var body: some View {
        Capsule()
            .foregroundColor(.clear)
            .frame(width: capsuleWidth, height: capsuleHeight)
            .padding()
    }
}

struct SendButton: View {
    
    let capsuleWidth: CGFloat
    let capsuleHeight: CGFloat
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(ColorManager.button)
                .frame(width: capsuleWidth, height: capsuleHeight)
                .padding()
            Image(systemName: "arrowtriangle.right.fill")
                .foregroundColor(.white)
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
