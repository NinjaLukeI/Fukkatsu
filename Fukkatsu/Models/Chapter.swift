//
//  Chapters.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 29/05/2023.
//

import Foundation

struct ChapterRoot: Decodable {
    let baseUrl: String
    let chapter: Chapter
}

struct Chapter: Codable, Identifiable{
    var id = UUID()
    
    let hash: String
    let data: [String]
    let dataSaver: [String]
    
    private enum CodingKeys: String, CodingKey{
        case hash
        case data
        case dataSaver
    }
    
}
