//
//  Feed.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 23/05/2023.
//

import Foundation

struct ChapterInfoRoot: Decodable {
    var data: [ChapterInfo]
    var total: Int
}

struct ChapterInfo: Decodable, Identifiable, Hashable, Equatable{
    let id: String
    let type: String // realistically will always be a chapter but whatever
    
    let attributes: chInfo_Attributes
    
    let relationships: [chapter_Relationships]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: ChapterInfo, rhs: ChapterInfo) -> Bool {
        return lhs.attributes.chapter == rhs.attributes.chapter
    }
    
}



struct chInfo_Attributes: Decodable{
    let volume: String?
    let chapter: String? //Which chapter it is
    let title: String? //title of chapter
    let publishAt: String
    let externalUrl: String?
    
}

struct chapter_Relationships: Decodable{
    let id: String
    let type: String
    
    let attributes: attributes?
}

//attributes for chapter using reference expansion to get information related to chapter
struct attributes: Decodable{
    let title: [String: String] //title of manga

}
