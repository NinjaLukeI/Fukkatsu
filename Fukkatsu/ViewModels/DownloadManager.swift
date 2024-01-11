//
//  DownloadManager.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 25/11/2023.
//

import Foundation
import Kingfisher
import SwiftUI

@MainActor class DownloadManager: ObservableObject{
    
    @Published var chapters: [ChapterRoot] = []
    @Published var pages: [String] = []
    @Published var loading = true
    @Published var chapter: ChapterInfo?
    @Published var progress = 0.0
    var chapterID: String = ""
    
    @FetchRequest(sortDescriptors: []) var downloads: FetchedResults<Download>
    @Environment(\.managedObjectContext) var moc
 
    
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
        
        self.chapterID = chapterID
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
        self.loading = true
        
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
            self.loading = false
            
        } catch {
            print(error)
        }
        
    }
    
    
    func downloadChapters() async throws{
        
        
        let downloader = ImageDownloader.default
        let cache = ImageCache.default
        
        var imageArray = [Data]()
        
        // Create manga directory
        // if a directory already exists, it'll retrieve an error but the error won't stop execution
        let mangaID = chapter?.relationships.first(where: {$0.id == "manga"})?.attributes?.title.first
        let mangaDirectory = getDocumentsDirectory().appendingPathComponent("Manga/\(String(describing: mangaID))")
        do {
            try FileManager.default.createDirectory(at: mangaDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating Manga directory: \(error)")
            return
        }

        // Create chapter directory
        let chapterDirectory = mangaDirectory.appendingPathComponent("Chapter/\(chapterID)")
        do {
            try FileManager.default.createDirectory(at: chapterDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating Chapter directory: \(error)")
            return
        }
        
        //collate all pages of manga
        for page in pages{
            
            if Task.isCancelled{
                try? FileManager.default.removeItem(at: chapterDirectory)
                if !downloads.isEmpty{
                    for item in downloads{
                        if item.chapter_id == chapterID{
                            moc.delete(item)
                            try? moc.save()
                        }
                    }
                }
            }
            
            
            let url = URL(string: page)
            let cached = cache.isCached(forKey: page)
            
            //check if image already exists in cache
            if cached{
                cache.retrieveImage(forKey: page) {result in
                    switch result{
                    case .success(let value):
                        imageArray.append((value.image?.jpegData(compressionQuality: 1))!)
                    case .failure(let error):
                        print(error)
                    }
                    
                }
            }
            
            //code for checking continuations and interruptions during downloads
            else{
                try await withCheckedThrowingContinuation { continuation in
                    Task{
                            downloader.downloadImage(with: url!) { result in
                                switch result {
                                case .success(let value):
                                    imageArray.append((value.image.jpegData(compressionQuality: 1))!)
                                    continuation.resume(returning: ())
                                case .failure(let error):
                                    print(error)
                                    continuation.resume(throwing: error)
                                }
                            }
                    }
                }
                
            }
        }
        
        //init a download object for coredata and add pages to file directory
        let download = Download(context: moc)
        
            for image in imageArray{
                let pageURL = chapterDirectory.appendingPathComponent("page\(String(describing: imageArray.firstIndex(of: image)))")
                try? image.write(to: pageURL)
                download.page = pageURL.absoluteString
                
                if let i = imageArray.firstIndex(of: image){
                    let index: Int = imageArray.distance(from: imageArray.startIndex, to: i)
                    download.order = Int64(index)
                    
                    download.chapter_id = chapterID
                    try? moc.save()
                    self.progress += 1
                    
                }
                
            }
        
        
        
    }
    
    
    func createMangaDirectory(mangaID: String) -> URL? {
        let documentsDirectory = getDocumentsDirectory()
        let mangaDirectory = documentsDirectory.appendingPathComponent("Manga/\(mangaID)")

        do {
            try FileManager.default.createDirectory(at: mangaDirectory, withIntermediateDirectories: true, attributes: nil)
            return mangaDirectory
        } catch {
            print("Error creating Manga directory: \(error)")
            return nil
        }
    }
    
    func createChapterDirectory(mangaDirectory: URL, chapterID: String) -> URL? {
        let chapterDirectory = mangaDirectory.appendingPathComponent("Chapter/\(chapterID)")

        do {
            try FileManager.default.createDirectory(at: chapterDirectory, withIntermediateDirectories: true, attributes: nil)
            return chapterDirectory
        } catch {
            print("Error creating Chapter directory: \(error)")
            return nil
        }
    }
    
}
