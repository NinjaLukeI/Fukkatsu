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
    @EnvironmentObject var mangaFeed: FeedViewModel
    
    @State private var isTapped = true
    
    @State var prevChapter = -1
    @State var nextChapter = -1
    
    var body: some View {
        
            TabView{
                ForEach(reader.pages, id: \.self) { page in
                    Page(page: page)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode.never))
            .onTapGesture(){
                isTapped.toggle() // when this is tapped the overlay for control will be toggled
            }
            .overlay(alignment: .top){
                if isTapped{
                    readerOverlay(chapter: chapter)
                }
            }
            .task{
                await reader.populate(chapterID: chapter.id)
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
        
        
        let dummy =  ChapterInfo(id: "5df4596c-febd-492e-bf0d-d98f59fd3f2b", type: "chapter", attributes: chInfo_Attributes(volume: "1", chapter: "1", title: "Friend", publishAt: "2020-05-23", externalUrl: "" ), relationships: [chapter_Relationships(id: "s", type: "manga", attributes: attributes(title: ["en":"20th Century Boys"]))])
                
        
        ReaderView(chapter: dummy)
        
    }
}

struct Page_Previews: PreviewProvider{
    static var previews: some View{
        
        Page(page: "https://i.pinimg.com/550x/cd/0d/37/cd0d37b3ae0290e0f7e7006049b042df.jpg")
    }
}
