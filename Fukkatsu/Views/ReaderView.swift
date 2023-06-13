//
//  Reader.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 29/05/2023.
//

import SwiftUI



struct ReaderView: View {
    
    let chapter: MangaFeed
    
    @StateObject private var reader = ReaderModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task{
                await reader.populate(chapterID: chapter.id)
                
                await reader.constructPages()
            
            }
            
        if reader.loading{
            
            ZStack{
                Color(.systemBackground)
                    .ignoresSafeArea()
            }
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .scaleEffect(3)
        }
        
        if (reader.pages.count != 0){
            TabView{
                ForEach(reader.pages, id: \.self) { page in
                    
                    Page(page: page)
                    
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        
        
        
        
        
    }
        
}

struct Page: View {
    
    let page: String
    
    var body: some View{
        
        AsyncImage(url: URL(string: page), scale: 2){ phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
                    .scaledToFit()
            case .failure:
                Image(systemName: "photo")
            @unknown default:
                //since the asyncimagephase enum isn't frozen
                //this unused fallback needs to be added to handle
                //any cases that might be added in the future:
                EmptyView()
            }
            
        }
    }
    
}



struct Reader_Previews: PreviewProvider {
    static var previews: some View {
        
        let dummy = MangaFeed(id: "1", type: "Chapter", attributes: feed_Attributes(volume: "1", chapter: "1", title: "Test", publishAt: "2020-05-23"))
        
        ReaderView(chapter: dummy)
    }
}

struct Page_Previews: PreviewProvider{
    static var previews: some View{
        
        Page(page: "https://i.pinimg.com/550x/cd/0d/37/cd0d37b3ae0290e0f7e7006049b042df.jpg")
    }
}