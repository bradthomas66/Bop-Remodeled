//
//  SessionHandler.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2021-05-09.
//

import Foundation
import SwiftUI
import Firebase
import Combine

//This class is an environment that handles events specific to a users session
class SessionHandler: ObservableObject {
    
    let currentUserId = Auth.auth().currentUser?.uid
    
    @Published var myChats = [Message]() {
        didSet {
            parseChats()
        }
    }
    
    @Published var myContacts = [Contact]() {
        didSet {
            parseContacts() //this will alter parsedContactsSorted which is published
        }
    }
    
    //storage of chats after they are manipulated for the view
    @Published var parsedChatsSorted: [ChatBarData] = []
    
    //storage of contacts after they are manipulated for the view
    @Published var parsedContactsSorted: [ContactBarData] = []
    
    //chat that is selected by user tap
    @Published var activeChat: ChatBarData? = nil
    @Published var activeCoordinate: CGPoint? = nil //coordinate of user tap
    
    //offset that sets popovers off screen
    @Published var popoverOffset: CGFloat = 0 {
        didSet {
            if popoverOffset > 0 {
                UIApplication.shared.endEditing() //resign keyboard
            }
        }
    }
    @Published var isShowingPopover: Bool = false  //boolean for popover display status
    @Published var anyParentHasBeenTapped: Bool = false //boolean for if a bubble is tapped
    @Published var scrollOffset: CGPoint = CGPoint(x: 1.0, y: -1.0) //coordinate set that tracks scroll position
    @Published var isShowingReplyPopover: Bool = false //boolean to handle message reply popover on dashboard
    
    @Published var contactAddError: Bool = false
    @Published var contactIsSelected: [Contact] = []
    
    @Published var activeTutorial:  String = "chats" {
        didSet { print (activeTutorial) }
    }
    
    @Published var hasSeenScoresTutorial: Bool = false
    @Published var hasSeenSendBopTutorial: Bool = false
    
    //query and observe incoming chats to current user
    func getChats() {
        DispatchQueue.main.async { [self] in
            userInformationDatabaseRoot.queryOrdered(byChild: "authId")
                .queryEqual(toValue: self.currentUserId)
                .observeSingleEvent(of: .value, with: { snapshot in
                    if let user = snapshot.value as? NSDictionary {
                        let currentUserUsername = user.allKeys[0] as! String
                        
                        self.myChats = [] //empty my chats so its refreshed with chats with new read status
                        
                        //attach an observer to the current username node.
                        let _ = chatDatabaseRoot.child(currentUserUsername).observe(DataEventType.childAdded) { snapshot in
                            if let chat = snapshot.value as? NSDictionary {
                                
                                let unreadInt = chat["unread"] as? Int
                                
                                //if message is read
                                if unreadInt == 0 {
                                    let unreadBool = false
                                    
                                    let chat = Message(sender: chat["sender"] as? String, recipient: currentUserUsername, emoji: chat["emoji"] as? String, timestamp: chat["timestamp"] as Any, unread: unreadBool, id: snapshot.key)
                                    
                                    //code below is to prevent double counting of messages
                                    if self.myChats.isEmpty == true {
                                        self.myChats.append(chat)
                                        print(self.myChats)
                                    } else {
                                        let filter = self.myChats.filter {$0.id == chat.id}
                                        if filter.isEmpty == true {
                                            self.myChats.append(chat)
                                        }
                                    }
                                    //if message is unread
                                } else {
                                    let unreadBool = true
                                    
                                    let chat = Message(sender: chat["sender"] as? String, recipient: currentUserUsername, emoji: chat["emoji"] as? String, timestamp: chat["timestamp"] as Any, unread: unreadBool, id: snapshot.key)
                                    
                                    //code below is to prevent double counting of messages
                                    if self.myChats.isEmpty == true {
                                        self.myChats.append(chat)
                                    } else {
                                        let filter = self.myChats.filter {$0.id == chat.id}
                                        if filter.isEmpty == true {
                                            self.myChats.append(chat)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    } else {
                        print (self.currentUserId!)
                        print ("The ID doesn't exist")
                    }
                })
        }
    }
    
    //query and calculate new score on incoming message not working - Observe DataEventType like chats????
    func getScore() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            var scores = [Double]() {
                didSet {
                    
                    var total: Double = 0
                    
                    for score in scores {
                        total += score
                        
                    }
                    
                    userInformationDatabaseRoot.queryOrdered(byChild: "authId")
                        .queryEqual(toValue: self?.currentUserId)
                        .observeSingleEvent(of: .value, with: { snapshot in
                            if let user = snapshot.value as? NSDictionary {
                                let currentUserUsername = user.allKeys[0] as! String
                                
                                let roundedTotal = lround(total)
                                
                                userInformationDatabaseRoot.child(currentUserUsername).updateChildValues(["score": roundedTotal])
                            }
                        }
                        )
                    
                }
            }
            
            if self?.myChats.isEmpty != true {
                for chat in self!.myChats {
                    userInformationDatabaseRoot.queryOrderedByKey()
                        .queryEqual(toValue: chat.sender)
                        .observeSingleEvent(of: .value, with: { snapshot in
                            if let user = snapshot.value as? NSDictionary {
                                let userInfo = user[chat.sender!] as? NSDictionary
                                let senderScore = userInfo!["score"] as! Double
                                
                                userInformationDatabaseRoot.queryOrderedByKey()
                                    .queryEqual(toValue: chat.recipient)
                                    .observeSingleEvent(of: .value, with: { snapshot in
                                        if let user = snapshot.value as? NSDictionary {
                                            let userInfo = user[chat.recipient!] as? NSDictionary
                                            let myScore = userInfo!["score"] as! Double
                                            
                                            let ratio = senderScore/myScore
                                            let result = pow(ratio, 0.1)
                                            
                                            scores.append(result)
                                        }
                                    })
                            }
                        })
                }
            }
        }
    }
    
    //query current users contacts
    func getContacts() {
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            userInformationDatabaseRoot.queryOrdered(byChild: "authId") //query our own authId to get our username
                .queryEqual(toValue: self.currentUserId)
                .observeSingleEvent(of: .value, with: { snapshot in
                    if let user = snapshot.value as? NSDictionary {
                        let currentUserUsername = user.allKeys[0] as! String
                        self.getScore() //update score of contacts before we query
                        self.myContacts = [] //empty myContacts so its refreshed with new scores
                        let _ = contactsDatabaseRoot.child(currentUserUsername).observe(.value, with: { snapshot in //within the contacts database, observe changes to our contacts
                            if let contacts = snapshot.value as? NSDictionary {
                                let contactUsernames: [String] = contacts.allKeys as! [String]
                                for contactUsername in contactUsernames { // for each contact under our username, query the user data
                                    let contactInfo = contacts[contactUsername] as? NSDictionary
                                    let contactPendingInt: Int = contactInfo?["pending"] as! Int
                                    userInformationDatabaseRoot.queryOrderedByKey()
                                        .queryEqual(toValue: contactUsername)
                                        .observeSingleEvent(of: .value, with: { snapshot in
                                            if let contact = snapshot.value as? NSDictionary {
                                                let contactsInfo = contact[contactUsername] as? NSDictionary
                                                let contactFirstName = contactsInfo?["firstName"] as? String
                                                let contactLastName = contactsInfo?["lastName"] as? String
                                                let contactEmoji = contactsInfo?["emoji"] as? String
                                                let contactAuthId = contactsInfo?["authId"] as? String
                                                let contactScore = contactsInfo?["score"] as? Int
                                                var contactPending: Bool = true
                                                
                                                if contactPendingInt == 0 {
                                                    contactPending = false
                                                    let contactObject = Contact(firstName: contactFirstName!, lastName: contactLastName!, score: contactScore!, username: contactUsername, emoji: contactEmoji!, authId: contactAuthId!, pending: contactPending)
                                                    
                                                    //code below is to prevent double counting of contacts
                                                    if self.myContacts.isEmpty == true {
                                                        self.myContacts.append(contactObject)
                                                    } else {
                                                        let filter = self.myContacts.filter({$0.username == contactObject.username})
                                                        if filter.isEmpty == true {
                                                            self.myContacts.append(contactObject)
                                                        }
                                                        
                                                    }
                                                } else {
                                                    contactPending = true
                                                    let contactObject = Contact(firstName: contactFirstName!, lastName: contactLastName!, score: contactScore!, username: contactUsername, emoji: contactEmoji!, authId: contactAuthId!, pending: contactPending)
                                                    
                                                    //code below is to prevent double counting of contacts
                                                    if self.myContacts.isEmpty == true {
                                                        self.myContacts.append(contactObject)
                                                    } else {
                                                        let filter = self.myContacts.filter({$0.username == contactObject.username})
                                                        if filter.isEmpty == true {
                                                            self.myContacts.append(contactObject)
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        })
                                }
                            } else {
                                print ("username doesn't exist")
                            }
                        })
                    } else {
                        print ("id doesn't exist")
                    }
                })
        }
    }
    
    //add user to current users contacts
    func addContact(username: String) {
        //DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        //first - query current username from current authId
        userInformationDatabaseRoot.queryOrdered(byChild: "authId")
            .queryEqual(toValue: self.currentUserId)
            .observeSingleEvent(of: .value, with: { snapshot in
                if !snapshot.exists() {
                    print (self.currentUserId ?? "")
                    print ("The ID doesn't exist")
                }
                else {
                    let user = snapshot.value as? NSDictionary
                    let currentUserUsername = user?.allKeys[0] as! String
                    
                    //Query contacts from current username
                    userInformationDatabaseRoot.queryOrderedByKey()
                        .queryEqual(toValue: username)
                        .observeSingleEvent(of: .value, with: { snapshot in
                            if !snapshot.exists() {
                                print (username)
                                print ("contact's username doesnt exist")
                                self.contactAddError = true
                            }
                            else {
                                let user = snapshot.value as? NSDictionary
                                
                                let newContactUsername = user?.allKeys[0] as! String
                                
                                let pendingStatus: [String: Bool] = [
                                    "pending": true,
                                ]
                                
                                let theirContactLocation = contactsDatabaseRoot.child(newContactUsername).child(currentUserUsername)
                                theirContactLocation.setValue(pendingStatus)
                            }
                        })
                }
            })
        //}
    }
    
    //add back a contact request
    func addBackContact(username: String) {
        //DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        userInformationDatabaseRoot.queryOrdered(byChild: "authId")
            .queryEqual(toValue: self.currentUserId)
            .observeSingleEvent(of: .value, with: { snapshot in
                if !snapshot.exists() {
                    print (self.currentUserId ?? "")
                    print ("The ID doesn't exist")
                }
                else {
                    let user = snapshot.value as? NSDictionary
                    let currentUserUsername = user?.allKeys[0] as! String
                    
                    //Query contacts from current username
                    contactsDatabaseRoot.queryOrderedByKey()
                        .queryEqual(toValue: currentUserUsername)
                        .observeSingleEvent(of: .value, with: { snapshot in
                            if !snapshot.exists() {
                                print (username)
                                print ("contact's username doesnt exist")
                                self.contactAddError = true
                            }
                            else {
                                let pendingStatus: [String: Bool] = [
                                    "pending": false,
                                ]
                                contactsDatabaseRoot.child(currentUserUsername).child(username).setValue(pendingStatus)
                                contactsDatabaseRoot.child(username).child(currentUserUsername).updateChildValues(["pending": false])
                            }
                        }
                        )
                }
            }
            )
        //}
    }
    
    func removeContact(username: String) {
        //DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        //first - query current username from current authId
        userInformationDatabaseRoot.queryOrdered(byChild: "authId")
            .queryEqual(toValue: self.currentUserId)
            .observeSingleEvent(of: .value, with: { snapshot in
                if !snapshot.exists() {
                    print (self.currentUserId ?? "")
                    print ("The ID doesn't exist")
                }
                else {
                    let user = snapshot.value as? NSDictionary
                    let currentUserUsername = user?.allKeys[0] as! String
                    
                    //Query contacts from current username
                    userInformationDatabaseRoot.queryOrderedByKey()
                        .queryEqual(toValue: username)
                        .observeSingleEvent(of: .value, with: { snapshot in
                            if !snapshot.exists() {
                                print (username)
                                print ("contact's username doesnt exist")
                                self.contactAddError = true
                            }
                            else {
                                contactsDatabaseRoot.child(currentUserUsername).child(username).removeValue()
                            }
                        })
                }
            })
        //}
    }
    
    func parseChats() {
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            var content: [String] = [] //array of received emojis
            var sortedContent: [(String, Int)] = [] //received emojis and their frequency: sorted.
            var maxFrequency: Dictionary<String, Int>.Values.Element? = 1 //maximum received emoji count
            
            //Create array of received emojis
            for row in self.myChats {
                content.append(row.emoji!)
            }
            
            //Find max value
            maxFrequency = Dictionary(content.map {($0, 1)}, uniquingKeysWith: +).values.max()
            
            //Sort content by values
            sortedContent = Dictionary(content.map {($0, 1)}, uniquingKeysWith: +).sorted(by: {($0.value > $1.value) ? true : false})
            
            //initialize the array
            DispatchQueue.main.async {
                self.parsedChatsSorted = []
            }
            
            var id: Int = 0
            
            //Update array for parsed information
            DispatchQueue.main.async {
                for (key,value) in sortedContent {
                    self.parsedChatsSorted.append(ChatBarData(emoji: key, score: value, size: (CGFloat(value) / CGFloat(maxFrequency!)), id: id))
                    id += 1
                }
                parsedChatsSorted.sort(by: {
                    if $0.score == $1.score {
                        if $0.emoji > $1.emoji { return true } else { return false }
                    } else { return false }
                })
            }
        }
    }
    
    func parseContacts() {
        DispatchQueue.global(qos: .userInteractive).async { [self] in
            var scores: [Int] = []
            var sortedContacts: [Contact]
            
            for contact in self.myContacts {
                scores.append(contact.score)
            }
            
            let maxScore: Int? = scores.max() ?? 1
            
            sortedContacts = myContacts.sorted(by: {($0.score > $1.score) ? true : false})
            
            DispatchQueue.main.async { [self] in
                self.parsedContactsSorted = []
                
                for contact in sortedContacts {
                    let size = calculateSize(contact: contact, maxScore: CGFloat(maxScore!))
                    self.parsedContactsSorted.append(ContactBarData(emoji: contact.emoji, name: contact.firstName, score: contact.score, size: size, pending: contact.pending))
                }
                
                func calculateSize(contact: Contact, maxScore: CGFloat) -> CGFloat {
                    let size: CGFloat = CGFloat(contact.score) / CGFloat(maxScore)
                    return size
                }
            }
        }
    }
    
    func findIndexOfParsedChat(_ chat: ChatBarData) -> Int {
        //DispatchQueue.global(qos: .userInteractive).async { [self] in
            if parsedChatsSorted.contains(chat) {
                guard let index = parsedChatsSorted.firstIndex(of: chat) else { return 1 }
                return index
            } else {
                return 1
            }
        //}
    }
    
    func toggleContactSelectionState(_ contact: Contact) {
        //DispatchQueue.global(qos: .userInteractive).async { [weak self] in
        if let index = self.myContacts.firstIndex(of: contact) {
            //DispatchQueue.main.async {
            self.myContacts[index].isSelected.toggle()
            //}
        }
        self.updateIsSelectedArray()
        //}
    }
    
    func updateIsSelectedArray() {
        //DispatchQueue.global(qos: .userInteractive).async { [self] in
        //DispatchQueue.main.async {
        self.contactIsSelected = []
        //}
        for contact in self.myContacts {
            if contact.isSelected == true {
                //DispatchQueue.main.async {
                self.contactIsSelected.append(contact)
                //}
            }
        }
        //}
    }
    
    func wipeContactSelectionState() {
        //DispatchQueue.global(qos: .userInitiated).async { [self] in
        if self.contactIsSelected.isEmpty != true {
            for contact in self.contactIsSelected {
                if let index = self.myContacts.firstIndex(of: contact) {
                    //DispatchQueue.main.async {
                    self.myContacts[index].isSelected.toggle()
                    //}
                    updateIsSelectedArray()
                }
            }
        }
        //}
    }
    
    @Published var percentage: CGFloat = 0 // what is percentage. Define this more clearly
    @Published var emojiTextFieldWrapperOpacity: Double = 1
    @Published var sendingMessageSpinnerAngle: CGFloat = 0
    @Published var sendingMessageSpinnerOpacity: Double = 0
    
    
    //TODO: Add spinning circle for message send before message has sent and add timeout for unsent messages
    func sendMessage (emoji: String) {
        DispatchQueue.global(qos: .utility).async { [self] in
            userInformationDatabaseRoot.queryOrdered(byChild: "authId")
                .queryEqual(toValue: Auth.auth().currentUser?.uid)
                .observeSingleEvent(of: .value, with: { [self] snapshot in
                    if !snapshot.exists() {
                        print (Auth.auth().currentUser?.uid ?? "")
                        print ("The ID doesn't exist")
                    }
                    else {
                        let user = snapshot.value as? NSDictionary
                        let currentUserUsername = user?.allKeys[0] as! String
                        
                        for contact in self.contactIsSelected {
                            let message: [String: Any] = [
                                "sender": currentUserUsername,
                                "emoji": emoji,
                                "timestamp": ServerValue.timestamp(),
                                "unread": true
                            ]
                            let newChat = chatDatabaseRoot.child(contact.username).childByAutoId()
                            newChat.setValue(message)
                            
                            DispatchQueue.main.async {
                                withAnimation(.linear(duration: 0.5)) { //send message confirmation
                                    self.sendingMessageSpinnerAngle = 0
                                    self.sendingMessageSpinnerOpacity = 0
                                    self.percentage = 1
                                    self.emojiTextFieldWrapperOpacity = 0
                                }
                            }
                        }
                    }
                })
        }
    }
    
    //Actions resulting from a single tap of the chat bar
    func handleBarTap(geometry: GeometryProxy, chat: ChatBarData) {
        //DispatchQueue.global(qos: .userInteractive).async {
        self.getChats()
        if self.currentUserId != nil { //avoiding problems with force unwrapping in setChatsAsRead before user has registered
            self.setChatsAsRead() //set whatever active chat matches as read
            objectWillChange.send()
        }
        //DispatchQueue.main.async {
        self.isShowingPopover = true //must occur before the display of the popover - popover must appear offscreen, then bounce up, otherwise if is showing occurs after the animation it wont animate
        self.anyParentHasBeenTapped = true
        self.activeCoordinate = CGPoint(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
        self.activeChat = ChatBarData(emoji: chat.emoji, score: chat.score, size: chat.size, id: chat.id)
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 10)) {
            self.popoverOffset = 0
        }
        //}
        //}
    }
    
    func setChatsAsRead() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            userInformationDatabaseRoot.queryOrdered(byChild: "authId")
                .queryEqual(toValue: self?.currentUserId)
                .observeSingleEvent(of: .value, with: { snapshot in
                    if let user = snapshot.value as? NSDictionary {
                        let currentUserUsername = user.allKeys[0] as! String
                        
                        let _ = chatDatabaseRoot.child(currentUserUsername).observe(DataEventType.childAdded) { snapshot in
                            if let chat = snapshot.value as? NSDictionary {
                                let chatEmoji = chat["emoji"] as! String
                                
                                if chatEmoji == self?.activeChat?.emoji {
                                    chatDatabaseRoot.child(currentUserUsername).child(snapshot.key).updateChildValues(["unread": false])
                                    self?.getChats()
                                }
                            }
                        }
                    } else {
                        print (self?.currentUserId! as Any)
                        print ("The ID doesn't exist")
                    }
                    
                })
        }
    }
    
    func handleOtherParentTap() {
        UIApplication.shared.endEditing() //resign keyboard
        self.isShowingPopover = true
        self.anyParentHasBeenTapped = true
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 10)) {
            self.popoverOffset = 0
        }
    }
    
    //Actions resulting from screen taps behind the popover
    func handleBackgroundTap(offScreenOffset: CGFloat) {
        UIApplication.shared.endEditing() //resign keyboard
        self.isShowingPopover = false
        self.isShowingReplyPopover = false
        self.contactAddError = false //resign contact add error message
        withAnimation(.linear(duration: 0.1)) {
            self.popoverOffset = offScreenOffset
        }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification Settings \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
