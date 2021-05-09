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
    
    //The model
    @Published private(set) var chatDatabase: ChatDatabase = initModel()
    
    static func initModel() -> ChatDatabase { //"static": Function on the type not the instance, this lets us run before self is available
        
        func getChats() -> [Message] {
            //This could be more complex, run server query, etc. for now...
            messageSample
        }
        
        return ChatDatabase(chatsToMe: getChats()) //Only return model once we intialize those key parameters
    }
    
    let firebaseTransform = FirebaseDateTransform()
    
    //User ViewModel
    let userHandler = UserHandler()
    
    //MARK: Access to the model
    var parsedChatsSorted: [ChatBarData] {
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
    
    func findIndexOfParsedChat(_ chat: ChatBarData) -> Int {
        chatDatabase.findIndexOfParsedChat(chat)
    }
    
    func sendMessage (emoji: String) { //user database has been reinitialized
        userHandler.updateIsSelectedArray()
        print("sending message...")
        print(userHandler.contactIsSelected)
        
        for contact in userHandler.contactIsSelected {
            print ("message to \(contact.username) is sent")
            let timestamp: [AnyHashable: Any] = ServerValue.timestamp()
            let message: [String: String] = [
                "sender": "me",
                "emoji": emoji,
                "timestamp": "time"
            ]
            let newChat = chatDatabaseRoot.child(contact.username).childByAutoId()
            newChat.setValue(message)
        }
    }
}
