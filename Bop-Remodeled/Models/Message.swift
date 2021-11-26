//
//  Message.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-12.
//

import Foundation
import Firebase

struct Message: Identifiable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return
            lhs.sender == rhs.sender &&
            lhs.recipient == rhs.recipient &&
            lhs.emoji == rhs.emoji &&
            TimeInterval(lhs.timestamp as! Int/1000) == TimeInterval(rhs.timestamp as! Int/1000) &&
            lhs.unread == rhs.unread &&
            lhs.id == rhs.id
    }
    
    let sender: String?
    let recipient: String?
    let emoji: String?
    let timestamp: Any
    var unread: Bool
    let id: String
}

//var messageSample: [Message] = [ //local storage of chats. This should update on app opening and when database changes
//    Message(sender: "Team Bop", recipient: "Team Bop", emoji: "👋"),
//    Message(sender: "bread44", recipient: "Team Bop", emoji: "👻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥴"),
//    Message(sender: "Team Bop", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "mthomas66", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "kimthomas45", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bread44", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bo.g", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bread44", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "kimthomas45", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bread44", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "kimthomas45", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bread44", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bread44", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "kimthomas45", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bread44", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bo.g", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "mthomas66", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bo.g", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bread44", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "mthomas66", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "bread44", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "kstarsenior", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "kstarsenior", recipient: "Team Bop", emoji: "🙄"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥴"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥴"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥵"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥵"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥵"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥵"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥵"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😘"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😘"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😘"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥴"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👨‍💻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👨‍💻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥴"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😱"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👨‍💻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👨‍💻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👨‍💻"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😱"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👩‍🍳"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👩‍🍳"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😱"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😱"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👩‍🍳"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👩‍🍳"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👩‍🍳"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😱"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👩‍🍳"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😱"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👩‍🍳"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😈"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😈"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😈"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😈"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🎃"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🎃"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🎃"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🎃"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥃"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥃"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥃"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😤"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😤"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "👋"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "😤"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🚀"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🤣"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🏓"),
//    Message(sender: "dmoneymike", recipient: "Team Bop", emoji: "🥵")]
