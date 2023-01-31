//
//  Helper.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 30/01/2023.
//

import Foundation


//Get covers
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
