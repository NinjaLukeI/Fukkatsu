//
//  MangaListView.swift/Users/luke./Documents/projects/Fukkatsu/Fukkatsu/Views
//  Fukkatsu
//
//  Created by Luke . on 06/12/2022.
//

import SwiftUI

struct MangaListView: View {
    
    @StateObject private var mangaList = MangaListModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        
    ]
    
    var body: some View {
        
        NavigationView{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 10){
                    
                    ForEach(mangaList.items){ item in
                        MangaView(manga: item)
                    }
                    
                }
                .padding(.horizontal)
            }
            .task{
                await mangaList.populate()
            }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .principal) {
                        
                        Text("Discovery").font(.title2).fontWeight(.semibold)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button {
                            
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .tint(.blue)
                        }
                    }
                }
            }
        
    }
    
}

struct MangaListView_Previews: PreviewProvider {
    static var previews: some View {
        MangaListView()
    }
}
