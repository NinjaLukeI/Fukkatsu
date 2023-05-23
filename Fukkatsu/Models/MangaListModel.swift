//
//  MangaListView-ViewModel.swift
//  Fukkatsu
//
//  Created by Luke . on 13/12/2022.
//

import Foundation


@MainActor class MangaListModel: ObservableObject{
    
    @Published var items: [Manga] = []
    
    func fetchManga() async -> [Manga] {
        
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
    
    func populate() async {
        let fetched = await fetchManga()
        items = fetched
    }
    
}
    

