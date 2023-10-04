//
//  MangaSearch.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 26/07/2023.
//

import Foundation

@MainActor class MangaSearch: ObservableObject{
    
    @Published var items: [Manga] = []
    @Published private(set) var viewState: ViewState?
    
    var limit: Int = 15
    var offset: Int = 0
    var total: Int = 0
    
    enum ViewState{
        case loading
        case finished
        case fetching
    }
    
    var isLoading: Bool {
        self.viewState == .loading
    }
    
    var isFetching: Bool {
        self.viewState == .fetching
    }
    
    private(set) var isLoaded: Bool = false
    
    func fetchManga(title: String) async {
        
        
        self.viewState = .loading
        defer {self.viewState = .finished}
        
        let queryParams: [URLQueryItem] = [
            URLQueryItem(name: "availableTranslatedLanguage[]", value: "en" ),
            URLQueryItem(name: "includes[]", value: "cover_art" ),
            URLQueryItem(name: "includes[]", value: "author" ),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "hasAvailableChapters", value: "1" ),
            URLQueryItem(name: "title", value: title),
            URLQueryItem(name: "order[relevance]", value: "desc"),
        ]
        
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.mangadex.org"
        url.path = "/manga"
        url.queryItems = queryParams
        
        
        var request = URLRequest(url: url.url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            
            let manga = try JSONDecoder().decode(MangaRoot.self, from: data)
            
            items = Array(Set(manga.data))
            self.total = manga.total
            self.isLoaded = true
            
        } catch {
            print(error)
        }
        
       
    }
    
    
    func fetchMore(title: String) async {
        
        self.offset += self.limit+1
        
        self.viewState = .fetching
        defer {self.viewState = .finished}
        
//        guard self.offset + self.limit <= self.items in future need to get total results frmo mangaroot
        
        let queryParams: [URLQueryItem] = [
            URLQueryItem(name: "availableTranslatedLanguage[]", value: "en" ),
            URLQueryItem(name: "includes[]", value: "cover_art" ),
            URLQueryItem(name: "includes[]", value: "author" ),
            URLQueryItem(name: "limit", value: String(self.limit)),
            URLQueryItem(name: "offset", value: String(self.offset)),
            URLQueryItem(name: "hasAvailableChapters", value: "1" ),
            URLQueryItem(name: "title", value: title),
            URLQueryItem(name: "order[relevance]", value: "desc"),
        ]
        
        
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.mangadex.org"
        url.path = "/manga"
        url.queryItems = queryParams
        
        
        var request = URLRequest(url: url.url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            
            let manga = try JSONDecoder().decode(MangaRoot.self, from: data)
            
            items += Array(Set(manga.data))
        } catch {
            print(error)
        }
        
//        if self.offset >= self.total{
//            self.offset = 0
//        }
        
    }
    
    
//    func populate(title: String = "") async {
//        let fetched = await fetchManga(title: title)
//        items = fetched
//    }
    
    func hasReachedEnd(of item: Manga) -> Bool{
        
        if item.id == self.items.last?.id{
            return true
        }
        return false
        
    }
    
}
