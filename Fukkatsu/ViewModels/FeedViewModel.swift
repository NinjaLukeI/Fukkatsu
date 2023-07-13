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
        case sorting
    }
    
    var isLoading: Bool {
        self.loadState == .loading
    }
    
    var isFetching: Bool {
        self.loadState == .fetching
    }
    
    private(set) var isLoaded: Bool = false
    
    
    
    func fetchFeed(mangaID: String) async{
        
        self.loadState = .loading
        defer{self.loadState = .finished}
        
        let queryParams = [
                    URLQueryItem(name: "translatedLanguage[]", value: "en" ),
                    URLQueryItem(name: "limit", value: "100" ),
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
                    self.items = manga.data
                    removeDuplicateElements()
                    
                    print("the unsorted feed is: \(self.items)")
                    
                    
                    
                } catch {
                    print(error)
                }
        
    }
    
    func populate(mangaID: String) async {
        await fetchFeed(mangaID: mangaID)
    }
    
    func removeDuplicateElements(){
        var uniqueItems = [ChapterInfo]()
        
        
        self.items = self.items.filter({
            ($0.attributes.externalUrl == nil)
        })
        
        for item in self.items{

            if !uniqueItems.contains(where: {$0.attributes.chapter == item.attributes.chapter}){
                uniqueItems.append(item)
            }
        }
        self.items = uniqueItems
    }
    
}







