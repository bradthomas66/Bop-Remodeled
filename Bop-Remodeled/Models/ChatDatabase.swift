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
    
    var parsedChatsSorted: [ChatBarData] = [] //storage of chats after they are manipulated
    
    var chatsToMe: [Message] {
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
            content.append(row.emoji)
        }
        
        //Find max value
        maxFrequency = Dictionary(content.map {($0, 1)}, uniquingKeysWith: +).values.max()
        
        //Sort content by values
        sortedContent = Dictionary(content.map {($0, 1)}, uniquingKeysWith: +).sorted(by: {($0.value > $1.value) ? true : false})
        
        //initialize the array
        parsedChatsSorted = []
        
        var id: Int = 0
        
        //Update array for parsed information
        for (key,value) in sortedContent {
            parsedChatsSorted.append(ChatBarData(emoji: key, score: value, size: (CGFloat(value) / CGFloat(maxFrequency!)), id: id))
            id += 1
        }
        print("done parsing chats")
    }
    
    func findIndexOfParsedChat(_ chat: ChatBarData) -> Int {
        if parsedChatsSorted.contains(chat) {
            guard let index = parsedChatsSorted.firstIndex(of: chat) else { return 1 }
            return index
        } else {
            return 1
        }
    }
    
}

