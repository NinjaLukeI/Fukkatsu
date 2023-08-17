//
//  SearchView.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 31/07/2023.
//

import SwiftUI

struct SearchView: View{

    @State private var queryString = ""
    
    @StateObject private var mangaSearch = MangaSearch()
    

    var body: some View{
        
        NavigationView{
            SearchContent(queryString: queryString)
                .toolbar{
                    ToolbarItem(placement: .principal) {
                        
                        Text("Search").font(.title3).fontWeight(.regular)
                    }
                    
                }
                .navigationBarTitleDisplayMode(.inline)

        }
        .searchable(text: $queryString, prompt: "Search For Manga")
        .keyboardType(.asciiCapable)
        .autocorrectionDisabled()
        .onSubmit(of: .search){
            Task{
                print(queryString)
                mangaSearch.offset = 0
                await mangaSearch.fetchManga(title: queryString)
                
            }
        }
        .environmentObject(mangaSearch)
        
        
        
    }

}

struct SearchContent: View{
    
    var queryString: String
    @Environment(\.isSearching) var isSearching
    
    @EnvironmentObject var mangaSearch: MangaSearch
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),

    ]
    
    
    var body: some View{
        VStack{
            if !mangaSearch.items.isEmpty{
                ScrollView{
                    
                    LazyVGrid(columns: columns, spacing: 10){
                        
                        ForEach(mangaSearch.items){ item in
                            NavigationLink(destination: FeedView(manga: MangaView(manga: item))){
                                
                                MangaView(manga: item)
                                    .task{
                                        if mangaSearch.hasReachedEnd(of: item) && !mangaSearch.isFetching && !mangaSearch.isLoading{
                                            
                                            await mangaSearch.fetchMore(title: queryString)
                                        }
                                    }
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                    .padding(.horizontal)
                }

                .navigationBarTitleDisplayMode(.inline)
            }
        }
        
        
        
        
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
