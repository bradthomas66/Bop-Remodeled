//
//  Message.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-12.
//

import Foundation
import Firebase

struct Message: Identifiable {
    let senderUsername: String
    let recipientUsername: String
    let content: String //of type Emoji
    let id = UUID()
    let date: String = "12/30/20"
    let time: String = "12:00am"
    //let timestamp: TimeInterval
}
