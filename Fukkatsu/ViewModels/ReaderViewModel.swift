//
//  Reader.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 29/05/2023.
//

import Foundation

@MainActor class ReaderViewModel: ObservableObject{
    
    @Published var chapters: [ChapterRoot] = []
    @Published var pages: [String] = []
    @Published var loading = false
    @Published var chapter: ChapterInfo?
    
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
        
        chapters = await fetchChapters(chapterID: chapterID)
        pages = await constructPages()
       await fetchChapter(chapterID: chapterID)
       

    }
    
    
    func constructPages() async -> [String] {
        self.loading = true
        
        var pages: [String] = []
        
        if !self.chapters.isEmpty{
            let baseUrl = self.chapters[0].baseUrl
            let hash = self.chapters[0].chapter.hash
            
            for data in self.chapters[0].chapter.data{
                let url = "\(baseUrl)/data/\(hash)/\(data)"
                pages.append(url)
            }
            self.loading = false
            
            return pages
        }
        else{
            return []
        }
        
    }
    
    //Return ChapterInfo object from ID
    func fetchChapter(chapterID: String) async{
        
        
        let queryParams = [
                    URLQueryItem(name: "includes[]", value: "manga"),
                ]
        
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.mangadex.org"
        url.path = "/chapter/\(chapterID)"
        url.queryItems = queryParams
    
        
        var request = URLRequest(url: url.url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            
            chapter = try JSONDecoder().decode(ChapterInfoReaderRoot.self, from: data).data
            
        } catch {
            print(error)
        }
        
    }
}
