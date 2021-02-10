//
//  ChatHandler.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-12.
//

import Foundation
import Combine
import SwiftUI

//View Model for drawing views related to the chats
class ChatHandler: ObservableObject {
    
    //Chat model
    @Published private(set) var chatDatabase: ChatDatabase = ChatDatabase()
    
    //MARK: Access to the model
    var parsedChatsSorted: [ChatBubbleData] {
        chatDatabase.parsedChatsSorted
    }
    
    var chatsToMe: [Message] {
        chatDatabase.chatsToMe
    }
    
    //MARK: Intents
    func addChatToMe(_ message: Message) {
        chatDatabase.addChatToMe(message)
    }
    
    func parseChats() {
        chatDatabase.parseChats()
    }
    
    func findIndexOfParsedChat(_ chat: ChatBubbleData) -> Int {
        chatDatabase.findIndexOfParsedChat(chat)
    }
}
