//
//  Reader.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 29/05/2023.
//

import SwiftUI
import Kingfisher


struct ReaderView: View {
    
    let chapter:  ChapterInfo
    
    @StateObject private var reader = ReaderViewModel()
    @State var pages: [String] = []
    @EnvironmentObject var mangaFeed: FeedViewModel
    
    @State var prevChapter = -1
    @State var nextChapter = -1
    
    var body: some View {
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task{
                await reader.populate(chapterID: chapter.id)
                
                await pages = reader.constructPages()
                
                
                //logic to get next and previous chapters

                if let chapter = mangaFeed.items.firstIndex(of: chapter){
                    if chapter < mangaFeed.items.count{
                        self.prevChapter = chapter-1
                        self.nextChapter = chapter+1
                    }
                    else if chapter == mangaFeed.items.count{
                        self.prevChapter = chapter-1
                    }
                    else if chapter == 1 {
                        self.nextChapter = chapter+1
                    }
                }
                    
            }.hidden()
        
        
        
        if reader.loading{
            
            ZStack{
                Color(.systemBackground)
                    .ignoresSafeArea()
            }
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .green))
                .scaleEffect(3)
        }
        
        if (pages.count > 0){
            TabView{
                ForEach(pages, id: \.self) { page in
                    
                    VStack{
                        Page(page: page)
                    }
                    
                    if(pages.last == page){
                        
                    }
                    
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
        
        KFImage.url(URL(string: page))
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
            .scaledToFit()
        
        
    }
    
}



struct Reader_Previews: PreviewProvider {
    static var previews: some View {
        
        let dummy =  ChapterInfo(id: "1", type: "Chapter", attributes: chInfo_Attributes(volume: "1", chapter: "1", title: "Test", publishAt: "2020-05-23", externalUrl: ""))
        
        let dummyPages: [String] = ["https://i.pinimg.com/736x/9c/d9/8d/9cd98d26d91eb17844174b70f0864fa4.jpg", "https://i.pinimg.com/550x/cd/0d/37/cd0d37b3ae0290e0f7e7006049b042df.jpg"]
        
        
        ReaderView(chapter: dummy, pages: dummyPages)
        
    }
}

struct Page_Previews: PreviewProvider{
    static var previews: some View{
        
        Page(page: "https://i.pinimg.com/550x/cd/0d/37/cd0d37b3ae0290e0f7e7006049b042df.jpg")
    }
}