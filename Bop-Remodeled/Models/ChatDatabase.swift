//
//  ChatDatabase.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-23.
//

import Foundation
import SwiftUI
import Firebase

//Model to hold chat data and interface with chat database
struct ChatDatabase {
    
    var parsedChatsSorted: [ChatBubbleData] = [] //storage of chats after they are manipulated
    
    var chatsToMe: [Message] = [ //local storage of chats. This should update on app opening and when database changes
        Message(senderUsername: "Team Bop", recipientUsername: "Team Bop", content: "👋"),
        Message(senderUsername: "bread44", recipientUsername: "Team Bop", content: "👻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥴"),
        Message(senderUsername: "Team Bop", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "mthomas66", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "kimthomas45", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bread44", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bo.g", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bread44", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "kimthomas45", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bread44", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "kimthomas45", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bread44", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bread44", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "kimthomas45", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bread44", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bo.g", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "mthomas66", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bo.g", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bread44", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "mthomas66", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "bread44", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "kstarsenior", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "kstarsenior", recipientUsername: "Team Bop", content: "🙄"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥴"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥴"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥵"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥵"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥵"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥵"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥵"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😘"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😘"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😘"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥴"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👨‍💻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👨‍💻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥴"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😱"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👨‍💻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👨‍💻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👨‍💻"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😱"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👩‍🍳"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👩‍🍳"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😱"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😱"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👩‍🍳"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👩‍🍳"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👩‍🍳"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😱"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👩‍🍳"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😱"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "👩‍🍳"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😈"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😈"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😈"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😈"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🎃"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🎃"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🎃"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🎃"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥃"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥃"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "🥃"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😤"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😤"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😤"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😤"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😤"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😤"),
        Message(senderUsername: "dmoneymike", recipientUsername: "Team Bop", content: "😤")] {
        didSet {
            parseChats()
        }
    }
    
    mutating func addChatToMe(_ message: Message) { //add a chat to the chatsToMe array
        self.chatsToMe.append(message)
    }
    
    mutating func parseChats() { //
        
        print("parsing chats...")
        
        var content: [String] = [] //array of received emojis
        var sortedContent: [(String, Int)] = [] //received emojis and their frequency: sorted.
        var maxFrequency: Dictionary<String, Int>.Values.Element? = 1 //maximum received emoji count
        
        //Create array of received emojis
        for row in chatsToMe {
            content.append(row.content)
        }
        
        //Find max value
        maxFrequency = Dictionary(content.map {($0, 1)}, uniquingKeysWith: +).values.max()
        
        //Sort content by values
        sortedContent = Dictionary(content.map {($0, 1)}, uniquingKeysWith: +).sorted(by: {($0.value < $1.value) ? true : false})
        
        //initialize the array
        parsedChatsSorted = []
        
        var id: Int = 0
        
        //Update array for parsed information
        for (key,value) in sortedContent {
            parsedChatsSorted.append(ChatBubbleData(content: key, frequency: value, size: (CGFloat(value) / CGFloat(maxFrequency!)), id: id))
            id += 1
        }
        
        //ratio between current bubble size and the bubble size before it
        for i in 0 ..< parsedChatsSorted.count - 1 {
            if i == 0 {
                parsedChatsSorted[i].zoomScalar = parsedChatsSorted[i].size
            } else {
                parsedChatsSorted[i].zoomScalar = parsedChatsSorted[i].size / parsedChatsSorted[i-1].size
            }
        }
        
        print("done parsing chats")
    }
    
    func findIndexOfParsedChat(_ chat: ChatBubbleData) -> Int {
        if parsedChatsSorted.contains(chat) {
            guard let index = parsedChatsSorted.firstIndex(of: chat) else { return 1 }
            return index
        } else {
            return 1
        }
    }
    
}

