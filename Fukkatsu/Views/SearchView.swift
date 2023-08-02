//
//  SearchView.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 31/07/2023.
//

import SwiftUI

struct SearchView: View{

    @ObservedObject private var mangaSearch = MangaSearch()

    var queryString: String
    @Environment(\.isSearching) var isSearching

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),

    ]

    var body: some View{
        
        Text("")
        

//        if isSearching{
//            ScrollView{
//
//                LazyVGrid(columns: columns, spacing: 10){
//
//                    ForEach(mangaSearch.items){ item in
//                        NavigationLink(destination: FeedView(manga: MangaView(manga: item))){
//
//                            MangaView(manga: item)
//                                .task{
//                                    if mangaSearch.hasReachedEnd(of: item) && !mangaSearch.isFetching && !mangaSearch.isLoading{
//
//                                        await mangaSearch.fetchMore()
//                                    }
//                                }
//                        }
//                        .buttonStyle(.plain)
//                    }
//
//                }
//                .padding(.horizontal)
//            }.background()
//
//
//                .onSubmit(of: .search){
//                    print("the query string is \(queryString)")
//                    Task {
//                        await mangaSearch.fetchManga(title: queryString)
//                    }
//                }
//
//            .navigationBarTitleDisplayMode(.inline)
//        }


    }

}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(queryString: "")
    }
}
