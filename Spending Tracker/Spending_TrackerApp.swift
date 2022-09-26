//
//  Spending_TrackerApp.swift
//  Spending Tracker
//
//  Created by Mario Elorza on 31-07-22.
//

import SwiftUI

@main
struct Spending_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
