//
//  MuscleMateApp.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import SwiftUI

@main
struct MuscleMateApp: App {
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
