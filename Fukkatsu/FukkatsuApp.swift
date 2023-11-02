//
//  FukkatsuApp.swift
//  Fukkatsu
//
//  Created by Luke . on 06/12/2022.
//

import SwiftUI
import FirebaseCore

@main
struct FukkatsuApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject private var dataController = DataController()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
