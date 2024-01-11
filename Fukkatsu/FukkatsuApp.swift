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
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var dataController = DataController()
    @StateObject var downloadManager = DownloadManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(downloadManager)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
