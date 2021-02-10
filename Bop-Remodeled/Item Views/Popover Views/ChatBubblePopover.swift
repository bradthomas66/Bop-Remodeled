//
//  ChatBubblePopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-29.
//

import SwiftUI

struct ChatBubblePopover: View {
    
    var parentViewHeight: CGFloat
    
    @ObservedObject var chatHandler: ChatHandler = ChatHandler()
    @EnvironmentObject var interactionHandler: DashboardInteractionHandler
    
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
    @EnvironmentObject var interactionHandler: DashboardInteractionHandler
    
    var body: some View {
        ScrollView {
            //replace with chats ordered by timestamp
            ForEach(chatHandler.chatsToMe) { chat in
                if chat.content == interactionHandler.activeChat?.content {
                    VStack {
                        HStack {
                            Text(chat.senderUsername)
                                .font(.headline)
                                .padding(.horizontal)
                            Spacer()
                            VStack {
                                Text(chat.time)
                                    .font(.subheadline)
                                Text(chat.date)
                                    .font(.footnote)
                            }.padding(.horizontal)
                        }
                        Divider()
                    }
                }
            }
        }
    }
}

struct ChatBubbleTitleBar: View {
    @EnvironmentObject var interactionHandler: DashboardInteractionHandler
    var body: some View {
        HStack {
            Text(interactionHandler.activeChat?.content ?? "")
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
            ChatBubblePopover(parentViewHeight: 460)
                .environmentObject(DashboardInteractionHandler())
        }
    }
}
