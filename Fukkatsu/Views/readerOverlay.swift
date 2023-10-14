//
//  readerOverlay.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 07/09/2023.
//

import SwiftUI

struct readerOverlay: View {
    
    
    @State var nextChapter: ChapterInfo?
    @State var prevChapter: ChapterInfo?
    
    @EnvironmentObject var mangaFeed: FeedViewModel
    @EnvironmentObject var reader: ReaderViewModel
    @EnvironmentObject var ch: ChapterIndex
    
    @Binding var currentPage: Int
    @Binding var selected: Int
    @State var totalPages: Int
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        
        VStack{
            
            //the proxy inherits the size of the parent view which in this case is just the screen
            GeometryReader{ proxy in
                RoundedRectangle(cornerRadius: 15)
                    .overlay(
                        HStack{
                            VStack(alignment: .leading){
                                
                                //Displays name of the manga
                                Text(reader.chapter?.relationships.first{
                                    $0.type == "manga"
                                }?.attributes?.title["en"] ?? "")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                    .lineLimit(1)
                                    
                                //Displays name of the chapter
                                Text("Ch \(reader.chapter?.attributes.chapter ?? "") - \(reader.chapter?.attributes.title ?? "")" ).font(.caption2)
                                    .fontWeight(.light)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                
                            }
                            
                            
                            Spacer()
                            
                            //Dismisses panel window
                            Button(action: {
                                dismiss()
                            }){
                                Image(systemName: "xmark")
                                    .foregroundColor(.red)
                            }
                            
                            
                           
                        }.frame(width: proxy.size.width - 100)
                            
                            
                            
                    ).padding(.horizontal, 30.0)
                    .frame(width: proxy.size.width , height: 60)
                    .foregroundColor(.black)
                    
            }
            
            HStack{
                
                //Logic for back button
                if(mangaFeed.items.indices.contains(ch.chIndex - 1)){
                    Button(action: {
                        
                        prevChapter = mangaFeed.items[ch.chIndex - 1]
                        ch.chIndex -= 1
                        Task {await reader.populate(chapterID: prevChapter!.id)
                            selected = 0
                        }
                        
                        
                    }){
                        Text("prev chapter")
                    }
                }
                
                Text("\(selected + 1) / \(reader.pages.count)")
                    .padding(.horizontal)
                
                //logic for next chapter button
                if(mangaFeed.items.indices.contains(ch.chIndex + 1)){
                    Button(action: {
                        
                        nextChapter = mangaFeed.items[ch.chIndex + 1]
                        ch.chIndex += 1
                        Task {await reader.populate(chapterID: nextChapter!.id)
                            selected = 0
                        }
                        
                        
                    }){
                        Text("next chapter")
                    }
                }
                
                
                
                
            }
            
        }
        
        
    }
}

struct readerOverlay_Previews: PreviewProvider {
    
    @State static var currPage = 0
    @State static var selected = 0
    
    
    
    static var previews: some View {
        
      
        let dummy =  ChapterInfo(id: "5df4596c-febd-492e-bf0d-d98f59fd3f2b", type: "chapter", attributes: chInfo_Attributes(volume: "1", chapter: "1", title: "Friend", publishAt: "2020-05-23", externalUrl: "" ), relationships: [chapter_Relationships(id: "s", type: "manga", attributes: attributes(title: ["en":"20th Century Boys"]))])
        
        let mangaID = "ad06790a-01e3-400c-a449-0ec152d6756a"
        
        //providing the preview provider mock environment objects
        readerOverlay(currentPage: $currPage, selected: $selected, totalPages: 10)
            .environmentObject({ () -> FeedViewModel in
                let envObj = FeedViewModel()
                Task{await envObj.populate(mangaID:mangaID)}
                return envObj
            }() )
            .environmentObject({ () -> ReaderViewModel in
                let envObj = ReaderViewModel()
                Task{await envObj.populate(chapterID: dummy.id)}
                return envObj
            }() )
            .environmentObject({ () -> ChapterIndex in
                let envObj = ChapterIndex()
                envObj.chIndex = 0
                return envObj
            }() )
        
    }
}
