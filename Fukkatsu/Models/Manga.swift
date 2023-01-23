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
    let title: [String: String]
    let description: [String: String]
    
    let year: Int?
    let lastChapter: String?
    //let status: String
}

//struct manga_Title: Decodable{
//    let title: String
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
//        guard let title = container.codingPath.first?.stringValue else {
//            throw NSError(domain: "com.json.decoder",
//                        code: -1,
//                        userInfo: [NSLocalizedFailureReasonErrorKey:"Chapter is missing a name"])
//            }
//
//            self.title = title
//    }
//
//}

struct manga_Description: Decodable{
    let description: String
}


struct manga_Relationships: Decodable{
    let id: String
    let type: String
    
    let attributes: relationship_Attributes?
}

struct relationship_Attributes: Decodable{
    let fileName: String? //cover fileName
    let authorName: String? //author name
    
    enum CodingKeys: String, CodingKey{
        case fileName
        
        case authorName = "name"
    }
}

struct DynamicCodingKeys: CodingKey {
  var stringValue: String
  var intValue: Int?
  
  init?(stringValue: String) {
    self.stringValue = stringValue
  }
    
    init?(intValue: Int) {
        return nil
    }
  
}


