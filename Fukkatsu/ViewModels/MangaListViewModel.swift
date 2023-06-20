//
//  MangaListView-ViewModel.swift
//  Fukkatsu
//
//  Created by Luke . on 13/12/2022.
//

import Foundation


@MainActor class MangaListViewModel: ObservableObject{
    
    @Published var items: [Manga] = []
    @Published private(set) var viewState: ViewState?
    
    var limit: Int = 15
    var offset: Int = 0
    
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
    
    func fetchManga(title: String = "") async {
        
        self.viewState = .loading
        defer {self.viewState = .finished}
        
        let queryParams: [URLQueryItem] = [
            URLQueryItem(name: "availableTranslatedLanguage[]", value: "en" ),
            URLQueryItem(name: "includes[]", value: "cover_art" ),
            URLQueryItem(name: "includes[]", value: "author" ),
            URLQueryItem(name: "limit", value: String(limit) ),
        ]
        
//        if(!title.isEmpty){
//            queryParams.append(URLQueryItem(name: "title", value: title))
//        }
        
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
            
            items = manga.data
        } catch {
            print(error)
        }
    }
    
    
    func fetchMore() async {
        
        self.offset += self.limit
        
        self.viewState = .fetching
        defer {self.viewState = .finished}
        
//        guard self.offset + self.limit <= self.items in future need to get total results frmo mangaroot
        
        let queryParams: [URLQueryItem] = [
            URLQueryItem(name: "availableTranslatedLanguage[]", value: "en" ),
            URLQueryItem(name: "includes[]", value: "cover_art" ),
            URLQueryItem(name: "includes[]", value: "author" ),
            URLQueryItem(name: "limit", value: String(self.limit)),
            URLQueryItem(name: "offset", value: String(self.offset)),
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
            
            items += manga.data
        } catch {
            print(error)
        }
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
