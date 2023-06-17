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
    
}

