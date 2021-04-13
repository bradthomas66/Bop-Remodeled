//
//  Bop_RemodeledApp.swift
//  Bop-Remodeled
//
//  Created by Brad Thomas on 2020-12-12.
//

import SwiftUI
import Firebase

@main
struct Bop_RemodeledApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @ObservedObject var authenticationHandler = AuthenticationHandler()
    @ObservedObject var chatHandler = ChatHandler()
    @ObservedObject var userHandler = UserHandler()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authenticationHandler.sessionState != nil {
                    DashboardView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(DashboardInteractionHandler())
                } else {
                    LaunchView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }.onAppear(perform: {
                authenticationHandler.listenForAuthState()
            })
        }
    }
    
    func boot() {
        
    }
}
