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
    
    @State private var swipeOffset = CGSize.zero
    @State private var emojiTextFieldHasContents: Bool = false
    @State private var swipeActivated: Bool = false {
        didSet {
            if swipeActivated == true {
                print("sending Message")
            }
        }
    }
        
    private var isShowingSendBar: Bool {
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
            
            SwipeBar(height: 100, width: 5)
                .opacity(isShowingSendBar ? 1 : 0)
                .offset(x: swipeOffset.width)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.width < 0 {
                                swipeOffset.width = gesture.translation.width
                                if swipeOffset.width <= -75 {
                                    swipeOffset.width = 0
                                    if isShowingSendBar {
                                        swipeActivated = true
                                    }
                                }
                            }
                        }
                )
        }
    }
}

struct TextFieldWrapperView: View {
    
    @Binding var emojiText: String
    @Binding var emojiTextFieldHasContents: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: circleLineWidth)
                .foregroundColor(ColorManager.button)
                .frame(width: circleWidth, height: circleHeight)
            TextFieldWrapper(emojiText: $emojiText, fontSize: emojiTextSize)
                .frame(width: circleWidth, height: circleHeight)
                .onChange(of: emojiText, perform: { value in
                    if value != "" {
                        emojiTextFieldHasContents = true
                    }
                })
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
