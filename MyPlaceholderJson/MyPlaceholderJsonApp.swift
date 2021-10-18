//
//  MyPlaceholderJsonApp.swift
//  MyPlaceholderJson
//
//  Created by iOS Development on 10/16/21.
//

import SwiftUI

@main
struct MyPlaceholderJsonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            /*ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)*/
            PlaceholderView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
