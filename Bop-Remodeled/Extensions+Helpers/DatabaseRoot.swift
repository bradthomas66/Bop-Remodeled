//
//  DatabaseRoot.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-03-01.
//

import Foundation
import Firebase

// Variables denoting database paths
let databaseRoot: DatabaseReference = Database.database(url: "https://bopremodeled-default-rtdb.firebaseio.com/").reference()
let chatDatabaseRoot = databaseRoot.child("chats")
let userInformationDatabaseRoot = databaseRoot.child("userInformation")
let scoresDatabaseRoot = databaseRoot.child("scores")
let contactsDatabaseRoot = databaseRoot.child("contacts")
let APNsDatabaseRoot = databaseRoot.child("APNs")

