//
//  ContentView.swift
//  Fukkatsu
//
//  Created by Luke . on 06/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel : AuthViewModel
    
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
            SearchView()
                .tabItem{
                    Image(systemName: "magnifyingglass")
                }
            Group {
                if viewModel.userSession != nil {
                    ProfileView()
                        .tabItem{
                            Image(systemName: "person")
                        }
                } else {
                    LoginView()
                        .tabItem{
                            Image(systemName: "person")
                        }
                    
                }
            }
        }
        .tint(.blue)
        .onAppear(){
            if #available(iOS 15, *) {
                let nav_appearance = UINavigationBarAppearance()
                nav_appearance.configureWithOpaqueBackground()
                UINavigationBar.appearance().standardAppearance = nav_appearance
                
                let tab_appearance = UITabBarAppearance()
                tab_appearance.configureWithOpaqueBackground()
                UITabBar.appearance().standardAppearance = tab_appearance

            }
        }
        
    }
    

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthViewModel())
    }
}
