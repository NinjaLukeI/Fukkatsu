//
//  MangaDetailView.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 30/01/2023.
//

import SwiftUI

struct MangaFeedView: View {
    
    let manga: MangaView
    
    @StateObject private var mangaFeed = MangaFeedModel()
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        HStack{manga}
            .task{
                await mangaFeed.populate(mangaID: manga.manga.id)
            }
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10){
                ForEach(mangaFeed.items){
                    item in
                    HStack{
                        
                        NavigationLink(destination: ReaderView(chapter: item)){
                            
                            Text("Chapter \(item.attributes.chapter): \(optionalCheck(value: item.attributes.title))")
                        }
                        
                        
                    }
                    .task{
                        print(item.id)
                    }
                    
                }
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
        
        MangaFeedView(manga: MangaView(manga: dummy))
    }
}
