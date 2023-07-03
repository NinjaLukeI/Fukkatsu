//
//  FeedViewModel.swift
//  Fukkatsu
//  Handles chapter retrieval
//  Created by Luke Ibeachum on 23/05/2023.
//

import Foundation
import OrderedDictionary

@MainActor class FeedViewModel: ObservableObject{
    
    
    @Published var items: [ChapterInfo] = []
    @Published var aggitems: [MangaAggregate] = []
    @Published private(set) var loadState: LoadState?
    var sortedChapters = OrderedDictionary<String, ChapterAgg>()
    
    
    enum LoadState{
        case loading
        case finished
        case fetching
        case sorting
    }
    
    var isLoading: Bool {
        self.loadState == .loading
    }
    
    var isFetching: Bool {
        self.loadState == .fetching
    }
    
    private(set) var isLoaded: Bool = false
    
    func getChapters() async{
        
        self.loadState = .loading
        defer{self.loadState = .finished}
        
        var queryParams: [URLQueryItem] = [
                    URLQueryItem(name: "translatedLanguage[]", value: "en" ),
                    URLQueryItem(name: "limit", value: "25" ),
                    URLQueryItem(name: "order[createdAt]", value: "asc" ),
                    URLQueryItem(name: "order[updatedAt]", value: "asc"),
                    URLQueryItem(name: "order[publishAt]", value: "asc"),
                    URLQueryItem(name: "order[readableAt]", value: "asc"),
                    URLQueryItem(name: "order[volume]", value: "asc"),
                    URLQueryItem(name: "order[chapter]", value: "asc"),
                ]
        
        print("how many chapters are here \(self.sortedChapters)")
        
        for(index, element) in sortedChapters.enumerated(){
            if(index == 25){
                break
            }
            queryParams.append(URLQueryItem(name: "ids[]", value: element.value.id))
            print(element.value.chapter)
        }
        
        print("QUERY PARAMS ARE \(queryParams)")
        
//        self.sortedChapters.forEach({
//
//            queryParams.append(URLQueryItem(name: "ids[]", value: $0.value.id))
//            counter+=1
//
//            if(counter==100){
//                return
//            }
//
        
        //if sortedchapters is > 100 then it needs to stop. PLEASE IMPLEMENT THIS FOR THE SCROLLING. A MAX OF 100 chapters only can be
        //sent to the query
        
//        print("the query params are \(queryParams)")
        
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.mangadex.org"
        url.path = "/chapter/"
        url.queryItems = queryParams
        
        var request = URLRequest(url: url.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
        do{
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            
            let manga = try JSONDecoder().decode(ChapterInfoRoot.self, from: data)
            
            self.isLoaded = true
//            manga.data = manga.data.sorted(by: {Double($0.attributes.chapter! )! < Double($1.attributes.chapter!)!}) //need to write in code to check if value of chapter is null
            self.items = manga.data
        } catch {
            print(error)
        }
        
    }
    
    func fetchFeed(mangaID: String) async{
        
        self.loadState = .loading
        defer{self.loadState = .finished}
        
        let queryParams = [
                    URLQueryItem(name: "translatedLanguage[]", value: "en" ),
                    URLQueryItem(name: "limit", value: "100" ),
                    URLQueryItem(name: "order[chapter]", value: "asc"),
                ]
                
                print(queryParams)
                
                var url = URLComponents()
                url.scheme = "https"
                url.host = "api.mangadex.org"
                url.path = "/manga/\(mangaID)/feed"
                url.queryItems = queryParams
                
                
                var request = URLRequest(url: url.url!)

                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                            
                do{
                    let (data, _) = try await URLSession.shared.data(from: url.url!)
                    
                    let manga = try JSONDecoder().decode(ChapterInfoRoot.self, from: data)
                    
                    self.isLoaded = true
                    self.items = manga.data
                    removeDuplicateElements()
                    
                    print("the unsorted feed is: \(self.items)")
                    
                    
                    
                } catch {
                    print(error)
                }
        
    }
    
    func populate(mangaID: String) async {
//        await mangaAggregate(mangaID: mangaID)
//        await sortAggregate()
//        await getChapters()
        await fetchFeed(mangaID: mangaID)
    }
    
    
    func mangaAggregate(mangaID: String) async{
        
        self.loadState = .fetching
        defer {self.loadState = .finished}
        
        let queryParams = [
            URLQueryItem(name: "translatedLanguage[]", value: "en" ),
        ]
        
        
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.mangadex.org"
        url.path = "/manga/\(mangaID)/aggregate"
        url.queryItems = queryParams
        
        
        var request = URLRequest(url: url.url!)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
        do{
            let (data, _) = try await URLSession.shared.data(from: url.url!)
            
            let manga = try JSONDecoder().decode(MangaAggregate.self, from: data)
            
            aggitems = [manga]
//            print(aggitems)
            
        } catch {
            print("the error in setting the aggregate is\(error)")

        }
        
    }
    
    func sortAggregate() async{

        
        self.loadState = .sorting
        defer{self.loadState = .finished}
        
        guard !self.aggitems.isEmpty else {
            return
        }
        
        var sortedVolumes = OrderedDictionary<String, Volume>(
            uniqueKeysWithValues: self.aggitems[0].volumes
        )

        var noneVolume: [String:Volume] = [:]
        
        sortedVolumes.forEach({
            if($0.key.description == "none"){
                noneVolume[$0.key] = $0.value
                sortedVolumes.removeValue(forKey: $0.key)
            }
        })

        sortedVolumes = sortedVolumes.sorted(by: {Double($0.value.volume)! < Double($1.value.volume)! })
        if(!noneVolume.isEmpty){
            sortedVolumes.insert(noneVolume.first!, at: sortedVolumes.endIndex)
        }
        
            
        print("THE SORTED VOLUMES ARE HERE: \(sortedVolumes)")

        sortedVolumes.forEach({volume in
            volume.value.chapters.forEach({
                self.sortedChapters[$0.key] = $0.value.self
            })
        })
        
        var noNumChapter: [String:ChapterAgg] = [:]

        self.sortedChapters.forEach({
            if(!$0.value.chapter.isDouble){
                noNumChapter[$0.key] = $0.value
                sortedChapters.removeValue(forKey: $0.key)
            }
        })
        
        self.sortedChapters = self.sortedChapters.sorted(by: {Double($0.value.chapter)! < Double($1.value.chapter)! })
        if(!noNumChapter.isEmpty){
            noNumChapter.forEach({
                sortedChapters.insert($0.self, at: sortedChapters.endIndex)
            })
        }
        

//        print("THE SORTED CHAPTERS ARE HERE: \(self.sortedChapters)")
    }
    
//    func sortFeed() async{
//
////
////        self.loadState = .sorting
////        defer{self.loadState = .finished}
//
//        guard !self.items.isEmpty else {
//            return
//        }
//
//        removeDuplicateElements()
//
//        var cantBeSorted: [ChapterInfo] = []
//
////        for (i, element) in self.items.enumerated(){
////            if !element.attributes.chapter!.isDouble{
////                cantBeSorted.append(element)
////                self.items.remove(at: i)
////            }
////        }
//
//        print("cant be sorted items: \(cantBeSorted)")
////        print("items with non-doubles removed\(self.items)")
//
////        self.items = self.items.sorted(by: {Double($0.attributes.chapter!)! < Double($1.attributes.chapter!)! })
//
//        cantBeSorted.forEach({
//            self.items.append($0.self)
//        })
//
//        print("the sorted feed is \(self.items)")
//
//
//
//
//    }
    
    func removeDuplicateElements(){
        var uniqueItems = [ChapterInfo]()
        
        for (i, element) in self.items.enumerated(){
            if !(element.attributes.externalUrl?.isEmpty ?? true){
                self.items.remove(at: i)
            }
        }
        
        for item in self.items{
            
            if !uniqueItems.contains(where: {$0.attributes.chapter == item.attributes.chapter}){
                uniqueItems.append(item)
            }
        }
        self.items = uniqueItems
    }

}







