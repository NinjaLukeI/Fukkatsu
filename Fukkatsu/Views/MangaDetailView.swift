//
//  MangaDetailView.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 30/01/2023.
//

import SwiftUI

struct MangaDetailView: View {
    
    let manga: MangaView
    
    @StateObject private var mangaChapters = MangaChaptersModel()
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        HStack{manga}
            .task{
                await mangaChapters.populate(mangaID: manga.manga.id)
            }
        ScrollView{
            LazyVGrid(columns: columns, spacing: 10){
                ForEach(mangaChapters.items){
                    item in
                    HStack{
                        Text("Chapter \(item.attributes.chapter)")
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
        
        MangaDetailView(manga: MangaView(manga: dummy))
    }
}
