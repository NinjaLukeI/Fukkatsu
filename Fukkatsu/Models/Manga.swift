//
//  Manga.swift
//  Fukkatsu
//
//  Created by Luke . on 12/12/2022.
//

import Foundation

struct MangaRoot: Decodable {
    let data: [Manga]
}

struct Manga: Decodable, Identifiable {
    let id: String
    let type: String
    
    let attributes: manga_Attributes
    let relationships: [manga_Relationships]
}

//main attributes for manga
struct manga_Attributes: Decodable {
    let title: manga_Title
    let description: manga_Description
    
    let year: Int?
    let lastChapter: String?
    //let status: String
}

struct manga_Title: Decodable{
    let en: String
    
}

struct manga_Description: Decodable{
    let en: String
}


struct manga_Relationships: Decodable{
    let id: String
    let type: String
    
    let attributes: relationship_Attributes?
}

struct relationship_Attributes: Decodable{
    let cover_filename: String
    
    enum CodingKeys: String, CodingKey{
        case cover_filename = "fileName"
    }
}



