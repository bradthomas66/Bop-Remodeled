//
//  ChatBarPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-29.
//

import SwiftUI

struct ChatBarPopover: View {
    
    var parentViewHeight: CGFloat
    
    @ObservedObject var chatHandler: ChatHandler = ChatHandler()
    @EnvironmentObject var interactionHandler: InteractionHandler
    
    var body: some View {
        ZStack {
            OutsideRectangle()
            VStack {
                ChatBubbleTitleBar()
                Divider().padding([.leading, .trailing])
                ChatsScrollView()
                Spacer()
            }
        }.frame(minHeight: parentViewHeight * 0.25, maxHeight: parentViewHeight * 0.4)
    }
}

struct ChatsScrollView: View {
    @ObservedObject var chatHandler: ChatHandler = ChatHandler()
    @EnvironmentObject var interactionHandler: InteractionHandler
    
    var body: some View {
        ScrollView {
            //replace with chats ordered by timestamp
            ForEach(chatHandler.chatsToMe) { chat in
                if chat.emoji == interactionHandler.activeChat?.emoji {
                    VStack {
                        HStack {
                            Text(chat.senderUsername)
                                .font(.headline)
                                .padding(.horizontal)
                            Spacer()
                            VStack {
                                Text("12:57am")
                                    .font(.subheadline)
                                Text("April 22/21")
                                    .font(.footnote)
                            }.padding(.horizontal)
                        }
                        Divider()
                    }.foregroundColor(ColorManager.darkGrey)
                }
            }
        }
    }
}

struct ChatBubbleTitleBar: View {
    @EnvironmentObject var interactionHandler: InteractionHandler
    var body: some View {
        HStack {
            Text(interactionHandler.activeChat?.emoji ?? "")
                .font(.largeTitle)
                .padding([.leading, .trailing])
                .padding(.top)
            Spacer()
        }
    }
}


struct ChatBubblePopoverView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Background()
            ChatBarPopover(parentViewHeight: 460)
                .environmentObject(InteractionHandler())
        }
    }
}
