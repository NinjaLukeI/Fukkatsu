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
        VStack{
            Image("op")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 97.0, height: 183.0)
                .shadow(radius: 2)
                //.clipped()
            
            HStack(alignment: .lastTextBaseline){
                Text(manga.attributes.title.en)
                    .fontWeight(.medium)
                    .padding(.bottom, 2.0)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption)
                    .lineLimit(2)
            }
            
            Text(manga.relationships[0].attributes!.authorName!)
                .font(.caption2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .allowsTightening(true)
                .offset(y: -8)
        }
        .frame(width: 115, height: 248)
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
