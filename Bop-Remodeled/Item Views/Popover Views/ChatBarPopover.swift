//
//  ChatBarPopover.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-29.
//

import SwiftUI

struct ChatBarPopover: View {
    
    var parentViewHeight: CGFloat
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
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
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    @State private var matchedChatsToMe: [Message] = [] //chats sorted by timestamp
    
    let constants = Constants()
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        
        ScrollView {
            //replace with chats ordered by timestamp
            ForEach(matchedChatsToMe) { chat in
                
                let chatDate = Date(timeIntervalSince1970: TimeInterval(chat.timestamp as! Int/1000))
                let chatSender = chat.sender!
                
                VStack {
                    HStack {
                        
                        Text(chat.sender ?? "")
                            .font(.headline)
                            .padding(.horizontal)
                            .foregroundColor(chat.unread ? ColorManager.button : ColorManager.darkGrey)
                       
                        Spacer()
                        
                        Button (action: { //reply button
                            sessionHandler.isShowingReplyPopover = true
                            sessionHandler.wipeContactSelectionState() //deselects all contacts
                            for contact in sessionHandler.myContacts {
                                if contact.username == chatSender {
                                    sessionHandler.toggleContactSelectionState(contact)
                                }
                            }
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: constants.circleStrokeWidth)
                                    .foregroundColor(chat.unread ? ColorManager.button : ColorManager.darkGrey)
                                Text("Reply")
                                    .cornerRadius(5)
                                    .foregroundColor(chat.unread ? ColorManager.button : ColorManager.darkGrey)
                                    .font(.footnote)
                                    .padding(.horizontal, 10)
                            }.frame(width: width * 0.15, alignment: .center)
                        }).padding(.horizontal)
                        
                        VStack {
                            Text(chatDate, style: .time) //time
                                .font(.subheadline)
                                .foregroundColor(chat.unread ? ColorManager.button : ColorManager.darkGrey)
                            Text(chatDate, style: .date) //month/year
                                .font(.footnote)
                                .foregroundColor(chat.unread ? ColorManager.button : ColorManager.darkGrey)
                            
                        }.padding(.horizontal)
                    }
                    Divider()
                }
            }
        }.onAppear(perform: {
            matchChats()
        })
    }
    func matchChats() {
        for chat in sessionHandler.myChats {
            if chat.emoji == sessionHandler.activeChat?.emoji {
                matchedChatsToMe.append(chat)
                matchedChatsToMe.sort {
                    TimeInterval($0.timestamp as! Int/1000) > TimeInterval($1.timestamp as! Int/1000) // sort by latest chats
                }
            }
        }
    }
}

struct ChatBubbleTitleBar: View {
    
    @EnvironmentObject var sessionHandler: SessionHandler
    
    var body: some View {
        HStack {
            Text(sessionHandler.activeChat?.emoji ?? "")
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
                .environmentObject(SessionHandler())
        }
    }
}
