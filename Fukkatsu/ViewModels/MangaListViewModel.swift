//
//  MangaListView-ViewModel.swift
//  Fukkatsu
//
//  Created by Luke . on 13/12/2022.
//

import Foundation


@MainActor class MangaListViewModel: ObservableObject{
    
    @Published var items: [Manga] = []
    
    func fetchManga(title: String = "") async -> [Manga] {
        
        
        if(title.isEmpty){
            
            let url = URL(string: "https://api.mangadex.org/manga?availableTranslatedLanguage[]=en&includes[]=cover_art&includes[]=author")!

            var request = URLRequest(url: url)

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        
            do{
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let manga = try JSONDecoder().decode(MangaRoot.self, from: data)
                
                return manga.data
            } catch {
                print(error)
                return []
            }
        }
        
        else{
            
            let MangaTitle = title.replacingOccurrences(of: " ", with: "%20") // sanitising query
            print("\(MangaTitle) is the title")
            
            let url = URL(string: "https://api.mangadex.org/manga?availableTranslatedLanguage[]=en&includes[]=cover_art&includes[]=author&title=\(MangaTitle)")!
            
            var request = URLRequest(url: url)

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        
            do{
                let (data, _) = try await URLSession.shared.data(from: url)
                
                let manga = try JSONDecoder().decode(MangaRoot.self, from: data)
                
                return manga.data
            } catch {
                print(error)
                return []
            }
            
        }
        
        
        
        
    }
    
    func populate(title: String = "") async {
        let fetched = await fetchManga(title: title)
        items = fetched
    }
    
}
    

