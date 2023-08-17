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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
