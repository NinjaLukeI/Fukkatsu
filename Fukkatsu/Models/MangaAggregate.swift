//
//  MangaAggregate.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 22/06/2023.
//

import Foundation
import OrderedDictionary

struct MangaAggregate: Decodable {
    let result: String
    let volumes: [String: Volume]
}

// MARK: - Volume
struct Volume: Decodable {
    let volume: String
    let count: Int
    let chapters: OrderedDictionary<String, ChapterAgg>
    
}

// MARK: - Chapter
struct ChapterAgg: Decodable {
    let chapter, id: String
    let others: [String]
    //let count: Int
}
