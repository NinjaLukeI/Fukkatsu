//
//  Reader.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 29/05/2023.
//

import Foundation

@MainActor class ReaderModel: ObservableObject{
    
    @Published var chapters: [ChapterRoot] = []
    @Published var pages: [String] = []
    @Published var loading = false
    
    
    func fetchChapters(chapterID: String) async -> [ChapterRoot]{
        
        let url = URL(string: "https://api.mangadex.org/at-home/server/\(chapterID)")!
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let chapter = try JSONDecoder().decode(ChapterRoot.self, from: data)
            
            return [chapter]
        } catch {
            print(error)
            return []
        }
        
    }
    
    func populate(chapterID: String) async {
        
        let fetched = await fetchChapters(chapterID: chapterID)
        chapters = fetched

    }
    
    
    func constructPages() async {
        self.loading = true
        
        if !self.chapters.isEmpty{
            let baseUrl = self.chapters[0].baseUrl
            let hash = self.chapters[0].chapter.hash
            
            for data in self.chapters[0].chapter.data{
                let url = "\(baseUrl)/data/\(hash)/\(data)"
                pages.append(url)
            }
            self.loading = false
        }
        
    }
}
