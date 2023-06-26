//
//  MangaAggregate.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 22/06/2023.
//

import Foundation


struct MangaAggregate: Decodable {
    let result: String
    var volumes: [String: Volume]
}

// MARK: - Volume
struct Volume: Decodable {
    let volume: String
    let count: Int
    var chapters: [String: ChapterAgg]
    
    
}

// MARK: - Chapter
struct ChapterAgg: Decodable {
    let chapter, id: String
    let others: [String]
    //let count: Int
}
