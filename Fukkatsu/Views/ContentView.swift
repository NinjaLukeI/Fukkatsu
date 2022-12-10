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
        
        NavigationView{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 40){
                    ForEach(0...2, id: \.self){ item in
                        MangaListView()
                        
                    }
                }
                .padding(.horizontal)
                    
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Discovery").font(.headline)
                        
                        SelectButton(isSelected: .constant(true), color: .green, text: "All")
 
                    }
                    
                }
        
                
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            print("Search")
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        

                    
                    
                }
            }
            //Spacer()
            
            
            
            
        }
        
        
        
    }
    
    init() {
        
        let navBarAppearance = UINavigationBarAppearance()
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        
    } //init
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
