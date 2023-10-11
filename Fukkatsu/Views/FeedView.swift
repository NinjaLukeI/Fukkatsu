//
//  MangaDetailView.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 30/01/2023.
//

import SwiftUI

struct FeedView: View {
    
    let manga: MangaView
    @State private var showingSheet = false
    @State private var selectedChapter: ChapterInfo? = nil
    
    @StateObject private var mangaFeed = FeedViewModel()
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        VStack{
            
            //shows the current manga
            HStack{manga}
                .task{
                    if mangaFeed.loadState != .finished{
                        await mangaFeed.populate(mangaID: manga.manga.id)
                    }
                }
            
            
            //shows the list of chapters
            ScrollView{
                LazyVGrid(columns: columns, spacing: 10){
                    ForEach(mangaFeed.items){
                        item in
                        HStack{
                            Button(action: {
                                selectedChapter = item //used for getting the current button
                                
                            }) {
                                Text("Chapter \(optionalCheck(value: item.attributes.chapter)): \(optionalCheck(value: item.attributes.title))")
                            }
                            .buttonStyle(.plain)
                            .task {
                                if mangaFeed.hasReachedEnd(of: item) && mangaFeed.loadState == .finished{
                                    await mangaFeed.fetchMore(mangaID: manga.manga.id)
                                }
                            }
                        }
                    }
                    //uses sheet to present chapter reader view
                    .fullScreenCover(item: $selectedChapter){ chapter in
                        ReaderView(chapter: chapter)
                            .environmentObject(mangaFeed)
                    }
                    
                }
                .task{
                    
                    print("current feed belongs to \(manga.manga.id)")
                    print("the aggregate items are\(mangaFeed.aggitems)")
                }
            }
        }
        
        
        
        
    }
    
}

struct MangaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let dummy = Manga(id: "ad06790a-01e3-400c-a449-0ec152d6756a",
                          type: "manga",
                          attributes: manga_Attributes(title: ["en": "20th Century Boys"], description: ["description": "description"], year: 2003, lastChapter: "2003"),
                          relationships: [manga_Relationships(id: "id", type: "type", attributes: relationship_Attributes(fileName: "b86017fe-3ec9-41d8-904c-c5f8031eb7de.jpg", authorName: "Urasawa Naoki"))])
        
        let url = "https://m.media-amazon.com/images/I/71Dj6z5rrzL._AC_UF894,1000_QL80_.jpg"
        
        FeedView(manga: MangaView(coverUrl: url, manga: dummy))
    }
}
