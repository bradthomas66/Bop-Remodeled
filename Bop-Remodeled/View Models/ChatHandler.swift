//
//  ChatHandler.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-12.
//

import Foundation
import Combine
import SwiftUI
import Firebase

//View Model for drawing views related to the chats
class ChatHandler: ObservableObject {
    
    //Chat model
    @Published private(set) var chatDatabase: ChatDatabase = ChatDatabase()
    
    //User view model
    @Published var userDatabase = UserDatabase()
    
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
    
//    func sendMessage (recipientUsername: String, emoji: String) {
//        let message: [String: String] = [
//            "sender": "me",
//            "emoji": emoji
//        ]
//
//        let newChat = chatDatabaseRoot.child(recipientUsername).child(timestamp)
//        newChat.setValue(message)
//    }
}
