//
//  ContentView.swift
//  Fukkatsu
//
//  Created by Luke . on 06/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        TabView{
            MangaListView()
                .tabItem{
                    Image(systemName: "book.closed")
                }
        }
        .tint(.blue)
        .onAppear(){
            if #available(iOS 15.0, *) {
                let navigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.configureWithDefaultBackground()
                UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                UINavigationBar.appearance().compactAppearance = navigationBarAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            }
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
