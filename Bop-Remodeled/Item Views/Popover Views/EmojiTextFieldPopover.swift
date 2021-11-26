//
//  EmojiTextFieldPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-28.
//

import SwiftUI

struct EmojiTextFieldPopover: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    var parentViewHeight: CGFloat
    let constants = Constants()
    
    @State var animationCompleted: Bool = false {
        didSet {
            sessionHandler.handleBackgroundTap(offScreenOffset: UIScreen.main.bounds.height)
            sessionHandler.emojiTextFieldWrapperOpacity = 1
            sessionHandler.wipeContactSelectionState()
            sessionHandler.percentage = 0
        }
    }
    
    var body: some View {
        ZStack {
            OutsideRectangle()
            VStack {
                HStack {
                    Text("Bop them")
                        .font(.title)
                        .foregroundColor(ColorManager.backgroundTopLeft)
                        .fontWeight(.bold)
                        .padding([.leading, .trailing], 45)
                        .padding(.top)
                    Spacer()
                }
                ZStack {
                    HStack {
                        Spacer()
                        Circle()
                            .foregroundColor(ColorManager.darkGrey)
                            .frame(width: constants.spinnerCircleRadius, height: constants.spinnerCircleRadius)
                            .offset(x: (constants.spinnerSpinRadius * cos(sessionHandler.sendingMessageSpinnerAngle)), y: (constants.spinnerSpinRadius * sin(sessionHandler.sendingMessageSpinnerAngle)))
                            .opacity(sessionHandler.sendingMessageSpinnerOpacity)
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                            .font(Font.system(size: 54))
                            .modifier(
                                OpacityAnimationModifier(totalOpacityChange: 1, percentage: sessionHandler.percentage) {
                                    withAnimation {
                                        self.animationCompleted = true
                                    }
                                }
                            )
                        Spacer()
                    }.padding(.vertical)
                    .padding(.bottom, 45)
                    
                    SendEmojiTextFieldBar(animationCompleted: $animationCompleted)
                        .padding(.vertical)
                        .opacity(sessionHandler.emojiTextFieldWrapperOpacity)
                        
                }
            }
        }.frame(minHeight: parentViewHeight * 0.33, maxHeight: parentViewHeight * 0.33)
    }
}

struct SendEmojiTextFieldBar: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    @State private var emojiText: String = ""
    @State private var swipeOffset = CGSize.zero
    @State private var emojiTextFieldHasContents: Bool = false
    
    @Binding var animationCompleted: Bool
    
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
        }.padding(.bottom, 45)
    }
}

struct TextFieldWrapperView: View {
    
    @Binding var emojiText: String
    @Binding var emojiTextFieldHasContents: Bool
    @EnvironmentObject var sessionHandler: SessionHandler
    
    private let constants = Constants()
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: constants.circleLineWidth)
                .foregroundColor(ColorManager.button)
                .frame(width: constants.circleWidth, height: constants.circleHeight)
            TextFieldWrapper(emojiText: $emojiText, fontSize: constants.emojiTextSize)
                .frame(width: constants.circleWidth, height: constants.circleHeight)
                .foregroundColor(ColorManager.darkGrey)
                .onChange(of: emojiText, perform: { value in
                    if value != "" {
                        emojiTextFieldHasContents = true
                    }
                })
            if emojiTextFieldHasContents {
                TextFieldWrapper(emojiText: $emojiText, fontSize: constants.emojiTextSize)
                    .frame(width: constants.circleWidth, height: constants.circleHeight)
                    .onLongPressGesture(minimumDuration: 1) {
                        triggerSendMessage()
                    }
                    .onChange(of: emojiText, perform: { value in
                        if value != "" {
                            emojiTextFieldHasContents = true
                        }
                    })
            }
        }
    }
    
    func simpleHapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func triggerSendMessage() {
//        withAnimation(.linear(duration: 0.5)) { //send message confirmation, loading until done. TODO THIS
//            sessionHandler.sendingMessageSpinnerOpacity = 1
//            while sessionHandler.sendingMessageSpinnerAngle < 360 {
//                sessionHandler.sendingMessageSpinnerAngle += 1
//
//                if sessionHandler.sendingMessageSpinnerAngle == 359 {
//                    sessionHandler.sendingMessageSpinnerAngle = 0
//                }
//            }
//        }
        simpleHapticSuccess()
        sessionHandler.popoverOffset = UIScreen.main.bounds.height
        emojiTextFieldHasContents = false
        sessionHandler.sendMessage(emoji: emojiText)
    }
}

struct EmojiTextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Background()
            EmojiTextFieldPopover(parentViewHeight: 640)
        }
    }
}
