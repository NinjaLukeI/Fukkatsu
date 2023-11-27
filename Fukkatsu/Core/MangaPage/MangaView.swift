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
    @State var manga: Manga?
    let id: String?
    
    @State private var animate = false
    
    
    var body: some View {
        
        
        
        VStack(alignment: .leading, spacing: 1){
            
            if manga != nil{
                KFImage.url(URL(string: coverUrl))
                    .placeholder{
                        ProgressView()
                    }
                    .cacheOriginalImage()
                    .loadDiskFileSynchronously()
                    .retry(maxCount: 3, interval: .seconds(5))
                    .onSuccess{ r in
                        print("Image obtained successfully: \(r)")
                    }
                    .onFailure{ e in
                        print("failure: \(e)")
                    }
                    .fade(duration: 0.2)
                    .resizable()
                    .shadow(radius: 3)
                    .frame(width: 110.0, height: 160.0)
                    
                    
                
                Text((manga!.attributes.title.first?.value ?? manga!.attributes.title["en"])!)
    //            Text("hi")
                    .fontWeight(.medium)
                    .scaledToFill()
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption)
                    .lineLimit(1)
                
                
                
                Text(manga!.relationships[0].attributes?.authorName ?? "No Author")
    //            Text("hi")
                    .font(.caption2)
                    .fixedSize(horizontal: false, vertical: true)
                    .allowsTightening(true)
                    .lineLimit(1)
            }
            
 
        }
        .opacity(animate ? 1 : 0)
        .animation(.easeIn, value: animate)
        .onAppear{animate = true}
        .frame(width: 101, height: 200)
        .task {
            
            if manga == nil && self.id != nil{
                self.manga = await mangaView.fetchManga(id: id!)
            }
            
            if let manga = manga {
                for (index, _) in manga.relationships.enumerated(){
                    
                    if(manga.relationships[index].type == "cover_art"){
                        await coverUrl = mangaView.populate(mangaID: manga.id, filename: manga.relationships[index].attributes!.fileName ?? "cover", highQuality: true)
                    }
                }
                
                print(coverUrl)
            }
            
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
        
        let id = "ad06790a-01e3-400c-a449-0ec152d6756a"
                               
        MangaView(coverUrl: url, manga: dummy, id: id)
        
    }
}


