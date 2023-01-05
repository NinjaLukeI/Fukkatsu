//
//  MangaView.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 03/01/2023.
//

import SwiftUI

struct MangaView: View {
    
    var manga: Manga
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1){
            
            ImageContainerView(image: "op")
                .frame(width: 100.0, height: 160.0)
                .shadow(radius: 3)
            
            
            Text(manga.attributes.title.en)
                .fontWeight(.medium)
                //.padding(.bottom, 2.0)
                .scaledToFill()
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
                .lineLimit(1)
            
            
            
            Text(manga.relationships[0].attributes!.authorName!)
                .font(.caption2)
                //.frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .allowsTightening(true)
                .lineLimit(1)
                
        }
        .frame(width: 101, height: 200)
        
        
    }
}

struct ImageContainerView: View {
    var image: String
    
    var body: some View {
        Color.clear
            .overlay{
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .clipped()
    }
}

struct MangaView_Previews: PreviewProvider {
    static var previews: some View {
        
        let dummy = Manga(id: "id",
                          type: "type",
                          attributes: manga_Attributes(title: manga_Title(
                            en: "example title"), description: manga_Description(en: "description"), year: 2003, lastChapter: "2003"),
                          relationships: [manga_Relationships(id: "id", type: "type", attributes: relationship_Attributes(fileName: "cover", authorName: "example author"))])
        

                               
        MangaView(manga: dummy)
        
    }
}
