//
//  ChatBarView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-04-12.
//

import SwiftUI

struct ChatBarView: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    //chat data input
    let chatToBar: ChatBarData
    
    //global constants
    let constants = Constants()
    
    @State private var frequencyFontWidth: CGFloat = 0.0
    
    @State private var thereAreUnreads: Bool = false
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        
        let barWidth: CGFloat = width * chatToBar.size * constants.barViewBarWidth
        let frequencyWidth: CGFloat = width * constants.frequencyFontScale
        
        HStack {
            Text(chatToBar.emoji)
                .font(Font.system(size: min(height, width) * constants.contentFontScale))
                .frame(width: min(height, width))
            
            ZStack {
                Rectangle()
                    .cornerRadius(constants.barViewCornerRadius)
                    .foregroundColor(ColorManager.lightGrey)
                    .frame(height: min(height, width) * constants.barViewLocalBarHeight)
                    .shadow(color: thereAreUnreads ? ColorManager.button : Color.clear, radius: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: constants.barViewCornerRadius)
                            .stroke(Color.clear, lineWidth: 4)
                            .shadow(color: Color(red: 192/255, green: 189/255, blue: 191/255), radius: 1, x: -1, y: 1)
                            .clipShape(RoundedRectangle(cornerRadius: constants.barViewCornerRadius))
                    )
                
                HStack {
                    ZStack {
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundColor(ColorManager.button)
                            .frame(height: min(height, width) * constants.barViewLocalBarHeight)
                            .background (
                                Text(String(chatToBar.score.withCommas()))
                                    .font(Font.system(size: frequencyWidth))
                                    .fixedSize(horizontal: true, vertical: false)
                                    .hidden()
                                    .readSize { size in
                                        frequencyFontWidth = size.width * constants.barViewTextPadding
                                    }
                            )
                        if frequencyFontWidth < barWidth {
                            Text(String(chatToBar.score.withCommas()))
                                .font(Font.system(size: frequencyWidth))
                                .foregroundColor(ColorManager.lightGrey)
                        }
                    }.frame(width: barWidth)
                    
                    if frequencyFontWidth > barWidth {
                        Text(String(chatToBar.score.withCommas()))
                            .font(Font.system(size: frequencyWidth))
                            .foregroundColor(ColorManager.darkGrey)
                    }
                    Spacer()
                }
            }
        }.onAppear(perform: {
            checkIfThereAreUnreads()
        })
        .padding(.horizontal)
    }
    
    func checkIfThereAreUnreads() {
        for chat in sessionHandler.myChats {
            if chat.emoji == chatToBar.emoji && chat.unread == true {
                thereAreUnreads = true
            }
        }
    }
}

struct ChatBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        GeometryReader { geometry in
            ChatBarView(chatToBar: ChatBarData(emoji: "😈", score: 3, size: 0.5, id: 1), width: geometry.size.width, height: geometry.size.height * 0.1)
                .environmentObject(SessionHandler())
        }
    }
}
