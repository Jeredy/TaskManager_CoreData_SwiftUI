//
//  TaskManager_CoreData_SwiftUIApp.swift
//  TaskManager_CoreData_SwiftUI
//
//  Created by André Almeida on 2022-08-09.
//

import SwiftUI

@main
struct TaskManager_CoreData_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
