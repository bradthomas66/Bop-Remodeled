//
//  ChatDatabase.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-23.
//

import Foundation
import SwiftUI

//Model to hold chat data and interface with chat database
struct ChatDatabase {
    
    var parsedChatsSorted: [ChatBubbleData] = []
    
    var chatsToMe: [Message] = [Message(senderUsername: "Team Bop", recipientUsername: "Team Bop", content: "👋"),
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
    
    mutating func addChatToMe(_ message: Message) {
        self.chatsToMe.append(message)
    }
    
    mutating func parseChats() {
        var content: [String] = []
        var sortedContent: [(String, Int)] = []
        var maxFrequency: Dictionary<String, Int>.Values.Element? = 1
        
        //Create array of content
        for row in chatsToMe {
            content.append(row.content)
        }
        
        //Find max value
        maxFrequency = Dictionary(content.map {($0, 1)}, uniquingKeysWith: +).values.max()
        
        //Sort content by values
        sortedContent = Dictionary(content.map {($0, 1)}, uniquingKeysWith: +).sorted(by: {($0.value < $1.value) ? true : false})
        
        //Empty the existing array
        parsedChatsSorted = []
        
        var id: Int = 0
        
        //Update array for parsed information
        for (key,value) in sortedContent {
            parsedChatsSorted.append(ChatBubbleData(content: key, frequency: value, size: CGFloat(value) / CGFloat(maxFrequency!), id: id))
            id += 1
        }
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
 
