//
//  MangaChaptersModel.swift
//  Fukkatsu
//  Handles chapter retrieval
//  Created by Luke Ibeachum on 23/05/2023.
//

import Foundation

@MainActor class FeedViewModel: ObservableObject{
    
    
    @Published var items: [Feed] = []
    
    
    
    func fetchFeed(mangaID: String) async -> [Feed]{
        
        let queryParams = [
            URLQueryItem(name: "translatedLanguage[]", value: "en" ),
            URLQueryItem(name: "limit", value: "30" ),
            URLQueryItem(name: "order[createdAt]", value: "asc" ),
            URLQueryItem(name: "order[updatedAt]", value: "asc"),
            URLQueryItem(name: "order[publishAt]", value: "asc"),
            URLQueryItem(name: "order[readableAt]", value: "asc"),
            URLQueryItem(name: "order[volume]", value: "asc"),
            URLQueryItem(name: "chapter]", value: "asc"),
        ]
        
        print(queryParams)
        
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.mangadex.org"
        url.path = "/manga/\(mangaID)/feed"
        url.queryItems = queryParams
        
//        let url = URL(string: "https://api.mangadex.org/manga/\(mangaID)/feed?limit=30&translatedLanguage[]=en&order[createdAt]=asc&order[updatedAt]=asc&order[publishAt]=asc&order[readableAt]=asc&order[volume]=asc&order[chapter]=asc")!
        
        
        
        var request = URLRequest(url: url.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
        do{
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            
            let manga = try JSONDecoder().decode(FeedRoot.self, from: data)
            
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
    
}
