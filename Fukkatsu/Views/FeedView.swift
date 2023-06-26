//
//  MangaDetailView.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 30/01/2023.
//

import SwiftUI

struct FeedView: View {
    
    let manga: MangaView
    
    @StateObject private var mangaFeed = FeedViewModel()
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        HStack{manga}
            .task{
                await mangaFeed.populate(mangaID: manga.manga.id)
                await mangaFeed.mangaAggregate(mangaID: manga.manga.id)
                if(mangaFeed.isLoaded){
                    mangaFeed.sortChapters()
                }
            }
        
        
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10){
                ForEach(mangaFeed.items){
                    item in
                    HStack{
                        
                        NavigationLink(destination: ReaderView(chapter: item)){
                            
                            Text("Chapter \(optionalCheck(value: item.attributes.chapter)): \(optionalCheck(value: item.attributes.title))")
                        }.buttonStyle(.plain)
                    }
                    
                    
                }
            }
            .task{
                print("current feed belongs to \(manga.manga.id)")
                print("the aggregate items are\(mangaFeed.aggitems)")
            }
        }
        
    }
    
}

struct MangaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let dummy = Manga(id: "id",
                          type: "type",
                          attributes: manga_Attributes(title: ["title": "title"], description: ["description": "description"], year: 2003, lastChapter: "2003"),
                          relationships: [manga_Relationships(id: "id", type: "type", attributes: relationship_Attributes(fileName: "cover", authorName: "example author"))])
        
        FeedView(manga: MangaView(manga: dummy))
    }
}
