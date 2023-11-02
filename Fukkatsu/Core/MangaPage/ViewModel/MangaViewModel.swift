//
//  MangaViewModel.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 05/01/2023.
//

import Foundation

@MainActor class MangaViewModel: ObservableObject{
    
    

    
    func getCover(mangaID: String, filename: String, highQuality: Bool) async -> String {
        
        var coverUrl: String
        
        if(highQuality == true){
            coverUrl = "https://uploads.mangadex.org/covers/" + mangaID + "/" + filename
            return coverUrl
        }
        else{
            coverUrl = "https://uploads.mangadex.org/covers/" + mangaID + "/" + filename
        }
       
        return ""

    }
    
    func populate(mangaID: String, filename: String, highQuality: Bool) async -> String{
        
        var url: String = ""
        url = await getCover(mangaID: mangaID, filename: filename, highQuality: true)
        
        
        if !url.isEmpty{
            return url
        }
        else{ return "" }
        
    }
    
    func fetchManga(id: String) async -> Manga?{
        
//        self.viewState = .loading
//        defer {self.viewState = .finished}
        
        let queryParams: [URLQueryItem] = [
            URLQueryItem(name: "includes[]", value: "cover_art" ),
            URLQueryItem(name: "includes[]", value: "author" ),
        ]
        
        
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.mangadex.org"
        url.path = "/manga/\(id)"
        url.queryItems = queryParams
        
        
        var request = URLRequest(url: url.url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            
            let manga = try JSONDecoder().decode(MangaSingleRoot.self, from: data)
            
            return manga.data
            
            
        } catch {
            print(error)
        }
        return nil
    }
   
    
}

