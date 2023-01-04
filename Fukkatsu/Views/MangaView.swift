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
            
            Text("Manga Author")
                .font(.caption2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .allowsTightening(true)
                .offset(y: -8)
        }
        .frame(width: 115, height: 248)
    }
}
