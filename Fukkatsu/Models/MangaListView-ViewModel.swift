//
//  MangaListView-ViewModel.swift
//  Fukkatsu
//
//  Created by Luke . on 13/12/2022.
//

import Foundation



extension MangaListView{
    @MainActor class MangaListModel: ObservableObject{
        
        @Published var mangaList = [Manga]()
        
        func addToList(){
            
            let url = URL(string: "https://api.mangadex.org/manga?availableTranslatedLanguage[]=en&includes[]=cover_art")!

            var request = URLRequest(url: url)

            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: url) {
                data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                //convert to jSON
                do {
                    let manga = try JSONDecoder().decode(MangaRoot.self, from: data)
                    
                    manga.data.forEach { item in
                        self.mangaList.append(item)
                    }
                        
                    
                    
                }
                catch{
                    print(error)
                }
            }
            
            task.resume()
            
            
        }
        
        func populate(){
            //
        }
        
        
        
        
    }
    
}
