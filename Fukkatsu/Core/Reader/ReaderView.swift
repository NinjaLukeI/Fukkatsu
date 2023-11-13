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
    
    
    @FetchRequest(sortDescriptors: []) var recents: FetchedResults<Recent>
    @Environment(\.managedObjectContext) var moc
    
    
    var body: some View {
        
    
        
        TabView(selection: $selected){
                ForEach(Array(reader.pages.enumerated()), id: \.element) { index, element in
                    Page(page: element)
                        .tag(index)
                        .onChange(of: selected){ val in
                            currentPage = val + 1 //tracks changes in selected tab to display page numbers
                            
                            for item in recents{
                                if item.chapter_id == reader.chapterID{
                                    item.page_num = Int16(val)
                                    try? moc.save()
                                }
                            }
                        }
                        .onAppear{
                            
                            for item in recents{
                                if item.chapter_id == reader.chapterID{
                                    selected = Int(item.page_num)
                                }
                            }
                            
                            if !recents.contains(where: {$0.chapter_id == reader.chapterID}){
                                let recent = Recent(context: moc)
                                
                                recent.chapter_id = reader.chapterID
                                recent.manga_id = reader.chapter?.relationships.first(where: {$0.type == "manga"})?.id
                                
                                try? moc.save()
                            }
                        
                        }
                        
                }
        }
            .tabViewStyle(.page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode.never))
            .onTapGesture(){
                isTapped.toggle() // when this is tapped the overlay for control will be toggled
            }
            .overlay(alignment: .top){
                if isTapped && reader.loading == false{
                    
                    ReaderOverlay(currentPage: $currentPage, selected: $selected, totalPages: reader.pages.count)
                        .environmentObject(reader)
                    
                }
            }
            .task{
                await reader.populate(chapterID: chapterID)
                
                
                if !recents.isEmpty{
                    for item in recents{
                        
                        //if the item in recents matches the current chapter
                        if item.chapter_id == reader.chapterID{
                            
                            item.recently_read = true
//                            selected = Int(item.page_num)
                            try? moc.save()
                        }
                        
                        else if item.chapter_id != reader.chapterID && item.recently_read == true{
                            
                            item.recently_read = false
                            
                        }
                    }
                }
                
                else{
                    
                    let recent = Recent(context: moc)
                    
                    recent.chapter_id = reader.chapterID
                    recent.manga_id = reader.chapter?.relationships.first(where: {$0.type == "manga"})?.id
                    
                    try? moc.save()
                    
                }
                
            }
        
    }
    
        
}

struct Page: View {
    
    let page: String
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
    @GestureState private var zoom = 1.0
    
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
            .scaleEffect(zoom)
            .gesture(
                MagnificationGesture()
                    .updating($zoom){ value, gestureState, transaction in
                        gestureState = value.magnitude
                    }
                
            )
        
        
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
