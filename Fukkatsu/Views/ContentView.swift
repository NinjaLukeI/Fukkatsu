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
        
        ScrollView{
            LazyVGrid(columns: columns, spacing: 5){
                ForEach(0...2, id: \.self){ item in
                    MangaListView()
                    
                }
            }
            	
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
