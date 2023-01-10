//
//  MangaViewModel.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 05/01/2023.
//

import Foundation

extension MangaView{
    @MainActor class MangaViewModel: ObservableObject{

        @Published var url: String = ""
        
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
        
        func populate(mangaID: String, filename: String, highQuality: Bool) async{
            let cover = await getCover(mangaID: mangaID, filename: filename, highQuality: true)
            url = cover
        }
        
        
        
        
    }
}
