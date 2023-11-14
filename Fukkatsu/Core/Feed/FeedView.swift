//
//  MangaDetailView.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 30/01/2023.
//

import SwiftUI

class ChapterIndex: ObservableObject{
    @Published var chIndex = 0
}

struct FeedView: View {
    
    
    
    let manga: MangaView
    @State var id: String = ""
    @State private var showingSheet = false
    @State private var selectedChapter: ChapterInfo? = nil
    
    @StateObject private var ch = ChapterIndex() //class for sharing chapter index
    
    @StateObject private var mangaFeed = FeedViewModel()
    
    @FetchRequest(sortDescriptors: []) var favourites: FetchedResults<Favourite>
    @Environment(\.managedObjectContext) var moc
    
    let columns = [
        GridItem(.flexible())
    ]
    
    
    
    var body: some View {
        
        VStack{
            
            //shows the current manga
            HStack{
                
                manga
                
                Button(action: {
    
                    
                    //again checking if the derived id is from the object or from the manga view in the object
                    if manga.manga?.id != nil{
                        self.id = manga.manga!.id
                    }
                    else{
                        self.id = manga.id!
                    }
                    
                    //checks through favourites store if the current item already exists there
                    if !favourites.isEmpty{
                        print("sloppy")
                        for item in favourites{
                            if item.id == id{
                                
                                print("DELETING!!!!")
                                moc.delete(item)
                                try? moc.save()
                                break
                            }
                            else{
                                print("bark")
                                let favourite = Favourite(context: moc)
                                
                                favourite.id = id
                                try? moc.save()
                            }

                        }
                    }
                    
                    else{
                        print("deez")
                        let favourite = Favourite(context: moc)
                        
                        favourite.id = id
                        
                        try? moc.save()
                    }
                    
                    
                    
                    
                }){
                    Image(systemName: "heart")
                }
                
            }
                .task{
                    if mangaFeed.loadState != .finished{
                        
                        // because loading from favouritesview and mangalistview is different
                        // i need different ways to access the ID.
                        // at some point i'll need to unify it so there's one way
                        
                        if let id = manga.id{
                            await mangaFeed.populate(mangaID: id)
                        }
                        
                        if let id = manga.manga?.id{
                            await mangaFeed.populate(mangaID: id)
                        }
                        
                    }
                }
            
            
            //shows the list of chapters
            ScrollView{
                LazyVGrid(columns: columns, spacing: 10){
                    ForEach(Array(mangaFeed.items.enumerated()), id: \.element){ index, item in
                        HStack{
                            Button(action: {
                                selectedChapter = item //used for getting the current button
                                ch.chIndex = index //used for getting index of given chapter
                                
                            }) {
                                Text("Chapter \(optionalCheck(value: item.attributes.chapter)): \(optionalCheck(value: item.attributes.title))")
                            }
                            .buttonStyle(.plain)
                            .task {
                                if mangaFeed.hasReachedEnd(of: item) && mangaFeed.loadState == .finished{
                                    
                                    //gets an id from either the mangaview object if it exists or the id
                                    if let id = manga.id{
                                        await mangaFeed.fetchMore(mangaID: id)
                                    }
                                    
                                    if let id = manga.manga?.id{
                                        await mangaFeed.fetchMore(mangaID: id)
                                    }
                                    
                                }
                            }
                        }
                    }
                    //uses sheet to present chapter reader view
                    .fullScreenCover(item: $selectedChapter){ chapter in
                        ReaderView(chapterID: chapter.id)
                            .environmentObject(mangaFeed)
                            .environmentObject(ch)
                    }
                    
                }
//                .task{
//
//                    print("current feed belongs to \(manga.manga!.id)")
//                    print("the aggregate items are\(mangaFeed.aggitems)")
//                }
            }
        }
        
        
        
        
    }
    
}

struct MangaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let dummy = Manga(id: "ad06790a-01e3-400c-a449-0ec152d6756a",
                          type: "manga",
                          attributes: manga_Attributes(title: ["en": "20th Century Boys"], description: ["description": "description"], year: 2003, lastChapter: "2003"),
                          relationships: [manga_Relationships(id: "id", type: "type", attributes: relationship_Attributes(fileName: "b86017fe-3ec9-41d8-904c-c5f8031eb7de.jpg", authorName: "Urasawa Naoki"))])
        
        let url = "https://m.media-amazon.com/images/I/71Dj6z5rrzL._AC_UF894,1000_QL80_.jpg"
        
        FeedView(manga: MangaView(coverUrl: url, manga: dummy, id: nil))
    }
}
