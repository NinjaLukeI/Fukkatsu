//
//  FeedViewModel.swift
//  Fukkatsu
//  Handles chapter retrieval
//  Created by Luke Ibeachum on 23/05/2023.
//

import Foundation
import OrderedDictionary

@MainActor class FeedViewModel: ObservableObject{
    
    
    @Published var items: [ChapterInfo] = []
    @Published var aggitems: [MangaAggregate] = []
    @Published private(set) var loadState: LoadState?
    var sortedChapters = OrderedDictionary<String, ChapterAgg>()
    
    enum LoadState{
        case loading
        case finished
        case fetching
    }
    
    var isLoading: Bool {
        self.loadState == .loading
    }
    
    var isFetching: Bool {
        self.loadState == .fetching
    }
    
    private(set) var isLoaded: Bool = false
    
    
    
    func fetchFeed(mangaID: String) async -> [ChapterInfo]{
        
        self.loadState = .loading
        defer{self.loadState = .finished}
        
        let queryParams = [
                    URLQueryItem(name: "translatedLanguage[]", value: "en" ),
                    URLQueryItem(name: "limit", value: "30" ),
                    URLQueryItem(name: "order[createdAt]", value: "asc" ),
                    URLQueryItem(name: "order[updatedAt]", value: "asc"),
                    URLQueryItem(name: "order[publishAt]", value: "asc"),
                    URLQueryItem(name: "order[readableAt]", value: "asc"),
                    URLQueryItem(name: "order[volume]", value: "asc"),
                    URLQueryItem(name: "order[chapter]", value: "asc"),
                ]
                
                print(queryParams)
                
                var url = URLComponents()
                url.scheme = "https"
                url.host = "api.mangadex.org"
                url.path = "/manga/\(mangaID)/feed"
                url.queryItems = queryParams
                
                
                var request = URLRequest(url: url.url!)

                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            
                do{
                    let (data, _) = try await URLSession.shared.data(from: url.url!)
                    
                    let manga = try JSONDecoder().decode(ChapterInfoRoot.self, from: data)
                    
                    self.isLoaded = true
                    return manga.data
                } catch {
                    print(error)
                    return []
                }
        
    }
    
    func populate(mangaID: String) async {
        let fetched = await fetchFeed(mangaID: mangaID)
        items = fetched
    }
    
    
    func mangaAggregate(mangaID: String) async{
        
        self.loadState = .fetching
        defer {self.loadState = .finished}
        
        let queryParams = [
            URLQueryItem(name: "translatedLanguage[]", value: "en" ),
        ]
        
        
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.mangadex.org"
        url.path = "/manga/\(mangaID)/aggregate"
        url.queryItems = queryParams
        
        
        var request = URLRequest(url: url.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
        do{
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            
            let manga = try JSONDecoder().decode(MangaAggregate.self, from: data)
            
            aggitems = [manga]
//            print(aggitems)
            
        } catch {
            print("the error in setting the aggregate is\(error)")

        }
        
    }
    
    func sortChapters(){

//        self.aggitems[0].volumes.forEach({
//            print(("the chapters are \($0.value.chapters.keys)")
//        }))
        
        var sortedVolumes = OrderedDictionary<String, Volume>(
            uniqueKeysWithValues: self.aggitems[0].volumes
        )

        var noneVolume: [String:Volume] = [:]
        var nextVolume: Int = 0
        
        sortedVolumes.forEach({
            if($0.key.description == "none"){
                noneVolume[$0.key] = $0.value
                nextVolume = (sortedVolumes.index(forKey: $0.key) ?? 0)
                sortedVolumes.removeValue(forKey: $0.key)
            }
        })

        sortedVolumes = sortedVolumes.sorted(by: {Double($0.value.volume)! < Double($1.value.volume)! })
        if(!noneVolume.isEmpty){
            sortedVolumes.insert(noneVolume.first!, at: nextVolume)
        }
        
            
        print("THE SORTED VOLUMES ARE HERE: \(sortedVolumes.count)")

        sortedVolumes.forEach({volume in
            volume.value.chapters.forEach({
                self.sortedChapters[$0.key] = $0.value.self
            })
        })
        
        var noNumChapter: [String:ChapterAgg] = [:]

        self.sortedChapters.forEach({
            if(!$0.value.chapter.isInt){
                noNumChapter[$0.key] = $0.value
                sortedChapters.removeValue(forKey: $0.key)
            }
        })
        
        self.sortedChapters = self.sortedChapters.sorted(by: {Double($0.value.chapter)! < Double($1.value.chapter)! })
        if(!noNumChapter.isEmpty){
            noNumChapter.forEach({
//                sortedChapters[$0.key.description] = $0.value.self
                sortedChapters.insert($0.self, at: sortedChapters.endIndex)
            })
        }
        

        print("THE SORTED CHAPTERS ARE HERE: \(self.sortedChapters)")
    }

}



