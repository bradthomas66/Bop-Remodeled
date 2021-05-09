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
    let emoji: String //of type Emoji
    let id = UUID()
    //let timestamp: [AnyHashable: Any]
}
