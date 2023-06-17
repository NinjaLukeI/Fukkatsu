//
//  MangaListView.swift/Users/luke./Documents/projects/Fukkatsu/Fukkatsu/Views
//  Fukkatsu
//
//  Created by Luke . on 06/12/2022.
//

import SwiftUI

struct MangaListView: View {
    
    @StateObject private var mangaList = MangaListViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        
    ]
    
    
    @State private var searchText: String = ""
    
    var body: some View {
        
        
        NavigationView{
            
            VStack{
                    ScrollView{
                        
                        LazyVGrid(columns: columns, spacing: 10){
                            
                            ForEach(mangaList.items){ item in
                                NavigationLink(destination: FeedView(manga: MangaView(manga: item))){
                                    
                                    MangaView(manga: item)
                                }
                                .buttonStyle(.plain)
                                
                            }
                        }
                        .padding(.horizontal)
                    }
                
                    .task{
                        if !searchText.isEmpty{
                            await mangaList.populate(title: searchText)
                        }
                        else{
                            await mangaList.populate()
                        }
                        
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    
                    .toolbar{
                        ToolbarItem(placement: .principal) {
                            
                            Text("Discovery").font(.title3).fontWeight(.regular)
                        }
                        
                    }
                    
                }
                
            }
        .searchable(text: $searchText)
        .keyboardType(.asciiCapable)
        .onChange(of: searchText) { value in
            print(value)
            //handles searching
            Task{
                if !searchText.isEmpty{
                    await mangaList.populate(title: value)
                }
                else{
                    await mangaList.populate()
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
