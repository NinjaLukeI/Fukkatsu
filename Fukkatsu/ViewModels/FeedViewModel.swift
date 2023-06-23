//
//  FeedViewModel.swift
//  Fukkatsu
//  Handles chapter retrieval
//  Created by Luke Ibeachum on 23/05/2023.
//

import Foundation

@MainActor class FeedViewModel: ObservableObject{
    
    
    @Published var items: [ChapterInfo] = []
    
    
    
    func fetchFeed(mangaID: String) async -> [ ChapterInfo]{
        
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
            print(error)
            return []
        }
        
    }
    
}

    

