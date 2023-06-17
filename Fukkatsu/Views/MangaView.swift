//
//  MangaView.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 03/01/2023.
//

import SwiftUI
import Kingfisher

struct MangaView: View {
    
    
    @StateObject private var mangaView = MangaViewModel()
    @State var coverUrl: String = ""
    let manga: Manga
    
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 1){
            
            KFImage.url(URL(string: coverUrl))
                .placeholder{
                    ProgressView()
                }
                .retry(maxCount: 3, interval: .seconds(5))
                .onSuccess{ r in
                    print("Image obtained successfully: \(r)")
                }
                .onFailure{ e in
                    print("failure: \(e)")
                }
                .resizable()
                .shadow(radius: 3)
                .frame(width: 110.0, height: 160.0)
            
            Text((manga.attributes.title.first?.value ?? manga.attributes.title["en"])!)
//            Text("hi")
                .fontWeight(.medium)
                .scaledToFill()
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
                .lineLimit(1)
            
            
            
            Text(manga.relationships[0].attributes!.authorName!)
//            Text("hi")
                .font(.caption2)
                .fixedSize(horizontal: false, vertical: true)
                .allowsTightening(true)
                .lineLimit(1)
                
        }
        .frame(width: 101, height: 200)
        .task {

            for (index, _) in manga.relationships.enumerated(){
                
                if(manga.relationships[index].type == "cover_art"){
                    await coverUrl = mangaView.populate(mangaID: manga.id, filename: manga.relationships[index].attributes!.fileName ?? "cover", highQuality: true)
                }
            }
            
            print(coverUrl)
        }
        
        
    }
}


struct MangaView_Previews: PreviewProvider {
    static var previews: some View {
        
        let dummy = Manga(id: "id",
                          type: "type",
                          attributes: manga_Attributes(title: ["title": "title"], description: ["description": "description"], year: 2003, lastChapter: "2003"),
                          relationships: [manga_Relationships(id: "id", type: "type", attributes: relationship_Attributes(fileName: "cover", authorName: "example author"))])
        
        let url = "https://static.wikia.nocookie.net/onepiece/images/c/c6/Volume_100.png/revision/latest?cb=20210903160940"
                               
        MangaView(coverUrl: url, manga: dummy)
        
    }
}


