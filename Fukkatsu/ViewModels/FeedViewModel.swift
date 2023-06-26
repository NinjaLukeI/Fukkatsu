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
    
    
    
    func fetchFeed(mangaID: String) async -> [ChapterInfo]{
        
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
    
    func populateAgg(mangaID: String) async {
        let fetched = await mangaAggregate(mangaID: mangaID)
        aggitems = fetched
    }
    
    func mangaAggregate(mangaID: String) async -> [MangaAggregate]{
        
        let queryParams = [
            URLQueryItem(name: "translatedLanguage[]", value: "en" ),
        ]
        
        print(queryParams)
        
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.mangadex.org"
        url.path = "/manga/\(mangaID)/aggregate"
        url.queryItems = queryParams
        
        
        var request = URLRequest(url: url.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
        do{
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            
            let manga = try JSONDecoder().decode([MangaAggregate].self, from: data)
            
            return manga
            
        } catch {
            print("the error in setting the aggregate is\(error)")
            return []
        }
        
    }
    
    func sortChapters(){
        
        var sortedVolumes = OrderedDictionary<String, Volume>(
            uniqueKeysWithValues: self.aggitems[0].volumes
        )
        
        var sortedChapters = OrderedDictionary<String, ChapterAgg>()
        
        sortedVolumes = sortedVolumes.sorted(by: {$0.key < $1.key})
        
        sortedVolumes.forEach({volume in
            volume.value.chapters.forEach({
                sortedChapters[$0.key] = $0.value.self
            })
        })
        
        sortedChapters = sortedChapters.sorted(by: {$0.key < $1.key})
        
        print("THE SORTED CHAPTERS ARE HERE: \(sortedChapters)")
        
        
//        var sortedChapters: [String:ChapterAgg] = [:]
        
        
    
        
//        var sortedChapters = OrderedDictionary<String, ChapterAgg>(
//            uniqueKeysWithValues: self.aggitems[0].vo
//        )
        
        
        
//        sortedVolumes = sortedVolumes.forEach({
//            $0.value.chapters.forEach({
//                sortedChapters[$0.key] = $0.value
//            })
//        })
        
    }
    
}



