//
//  ContactBarView.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-04-12.
//

import SwiftUI
import Foundation
import Combine

struct ContactBarView: View {
    
    let constants = Constants()
    let contactToBar: ContactBarData
    @State private var scoreFontWidth: CGFloat = 0.0
    
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        
        let barWidth: CGFloat = width * contactToBar.size * constants.barViewBarWidth
        let scoreWidth: CGFloat = width * constants.scoreFontScale
        
        HStack {
            VStack {
                Text(contactToBar.emoji)
                    .font(Font.system(size: min(height, width) * constants.emojiFontScale))
                Group {
                    if contactToBar.pending == true {
                        Text(contactToBar.name)
                        .font(Font.system(size: min(height, width) * constants.nameFontScale))
                        .foregroundColor(ColorManager.darkGrey)
                    } else {
                        Text(contactToBar.name)
                        .font(Font.system(size: min(height, width) * constants.nameFontScale))
                        .foregroundColor(ColorManager.lightGrey)
                    }
                }
            }.frame(width: min(height, width))
            
            ZStack {
                Rectangle()
                    .cornerRadius(constants.barViewCornerRadius)
                    .foregroundColor(ColorManager.lightGrey)
                    .frame(height: min(height, width) * constants.barViewLocalBarHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: constants.barViewCornerRadius)
                            .stroke(Color.clear, lineWidth: 4)
                            .shadow(color: Color(red: 192/255, green: 189/255, blue: 191/255), radius: 1, x: -1, y: 1)
                            .clipShape(RoundedRectangle(cornerRadius: constants.barViewCornerRadius))
                    )
                
                HStack {
                    ZStack {
                        Rectangle()
                            .cornerRadius(constants.barViewCornerRadius)
                            .foregroundColor(ColorManager.button)
                            .frame(height: min(height, width) * constants.barViewLocalBarHeight)
                            .background (
                                Text(String(contactToBar.score.withCommas()))
                                    .font(Font.system(size: scoreWidth))
                                    .fixedSize(horizontal: true, vertical: false)
                                    .hidden()
                                    .readSize { size in
                                        scoreFontWidth = size.width * constants.barViewTextPadding
                                    }
                            )
                        if scoreFontWidth < barWidth { //if score text is smaller than bar width, put it inside the bar
                            Text(String(contactToBar.score.withCommas()))
                                .font(Font.system(size: scoreWidth))
                                .foregroundColor(ColorManager.lightGrey)
                        }
                    }.frame(width: barWidth)
                    
                    if scoreFontWidth > barWidth { //if score text is wider than bar width, put it outside the bar
                        Text(String(contactToBar.score.withCommas()))
                            .font(Font.system(size: scoreWidth))
                            .foregroundColor(ColorManager.darkGrey)
                    }
                    Spacer()
                }
            }
        }.padding(.horizontal)
    }
}

struct ContactBarView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            ContactBarView(contactToBar: ContactBarData(emoji: "🙄", name: "Brad Thomas", score: 40000, size: 0.15, pending: true), width: geometry.size.width, height: geometry.size.height*0.1)
        }
    }
}
