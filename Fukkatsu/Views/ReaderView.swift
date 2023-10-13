//
//  Reader.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 29/05/2023.
//

import SwiftUI
import Kingfisher


struct ReaderView: View {
    
    @State var chapterID = ""
    
    @StateObject private var reader = ReaderViewModel()
    @EnvironmentObject var mangaFeed: FeedViewModel
    @EnvironmentObject var ch: ChapterIndex
    
    @State private var isTapped = true
    @State private var selected: Int = 0 //used in tabview
    @State var currentPage = 1
    @State var totalPages = 0
    
    
    var body: some View {
        
        TabView(selection: $selected){
                ForEach(Array(reader.pages.enumerated()), id: \.element) { index, element in
                    Page(page: element)
                        .tag(index)
                        .onChange(of: selected){ val in
                            currentPage = val + 1 //tracks changes in selected tab to display page numbers
                        }
                        
                }
            }
            .tabViewStyle(.page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode.never))
            .onTapGesture(){
                isTapped.toggle() // when this is tapped the overlay for control will be toggled
            }
            .overlay(alignment: .top){
                if isTapped && reader.loading == false{
                    
                    readerOverlay(currentPage: $currentPage, selected: $selected, totalPages: reader.pages.count)
                        .environmentObject(reader)
                    
                }
            }
            .task{
                await reader.populate(chapterID: chapterID)
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
                
        let mangaID = "ad06790a-01e3-400c-a449-0ec152d6756a"
        
        //providing the preview with mock environment objects for FVM and CI class
        ReaderView(chapterID: dummy.id)
            .environmentObject({ () -> FeedViewModel in
                let envObj = FeedViewModel()
                Task{await envObj.populate(mangaID:mangaID)}
                return envObj
            }() )
            .environmentObject({ () -> ChapterIndex in
                let envObj = ChapterIndex()
                envObj.chIndex = 0
                return envObj
            }() )
        
    }
}

struct Page_Previews: PreviewProvider{
    static var previews: some View{
        
        Page(page: "https://i.pinimg.com/550x/cd/0d/37/cd0d37b3ae0290e0f7e7006049b042df.jpg")
    }
}
