//
//  MangaListView-ViewModel.swift
//  Fukkatsu
//
//  Created by Luke . on 13/12/2022.
//

import Foundation


@MainActor class MangaListViewModel: ObservableObject{
    
    @Published var items: [Manga] = []
    
    func fetchManga(title: String = "") async{
        
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "availableTranslatedLanguage[]", value: "en" ),
            URLQueryItem(name: "includes[]", value: "cover_art" ),
            URLQueryItem(name: "includes[]", value: "author" ),
        ]
        
        if(!title.isEmpty){
            queryParams.append(URLQueryItem(name: "title", value: title))
        }
        
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
        
    }
    
    
//    func populate(title: String = "") async {
//        let fetched = await fetchManga(title: title)
//        items = fetched
//    }
    
    
    
}
