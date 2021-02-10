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

    var body: some Scene {
        WindowGroup {
            LaunchView()
//            DashboardView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .environmentObject(DashboardInteractionHandler())
        }
    }
}
