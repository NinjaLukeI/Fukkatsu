//
//  MangaListView.swift/Users/luke./Documents/projects/Fukkatsu/Fukkatsu/Views
//  Fukkatsu
//
//  Created by Luke . on 06/12/2022.
//

import SwiftUI

struct MangaListView: View {
    
    @ObservedObject private var mangaList = MangaListViewModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        
    ]
    
    
    @State private var searchText = ""
    
    var body: some View {
        
        
        NavigationView{
            
                    ScrollView{
                        
                        LazyVGrid(columns: columns, spacing: 10){
                            
                            ForEach(mangaList.items){ item in
                                NavigationLink(destination: FeedView(manga: MangaView(manga: item))){
                                    
                                    MangaView(manga: item)
                                        .task{
                                            if mangaList.hasReachedEnd(of: item) && !mangaList.isFetching && !mangaList.isLoading{
                                                
                                                await mangaList.fetchMore()
                                                
                                            }
                                                
                                        }
                                    
                                }
                                .buttonStyle(.plain)  
                            }
                            
                        }
                        .padding(.horizontal)
                    }.overlay(SearchView(queryString: searchText))
                
                    .task{
                        if !mangaList.isLoaded {
                            await mangaList.fetchManga()
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    
                    .toolbar{
                        ToolbarItem(placement: .principal) {
                            
                            Text("Discovery").font(.title3).fontWeight(.regular)
                        }
                        
                    }
            }
        .searchable(text: $searchText)
        .keyboardType(.asciiCapable)
        .autocorrectionDisabled()
        
    }
    
}

struct MangaListView_Previews: PreviewProvider {
    static var previews: some View {
        MangaListView()
    }
}


struct SearchView: View{
    
    var queryString: String
    @Environment(\.isSearching) var isSearching
    
    var body: some View{
        
        if isSearching{
            Image("op")
        }
        
    }
    
}
