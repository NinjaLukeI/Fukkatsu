//
//  MangaAggregate.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 22/06/2023.
//

import Foundation

struct MangaAggregate {
    let result: String
    let volumes: [String: Volume]
}

// MARK: - Volume
struct Volume {
    let volume: String
    let count: Int
    let chapters: [String: ChapterAgg]
}

// MARK: - Chapter
struct ChapterAgg {
    let chapter, id: String
    let others: [String]
    let count: Int
}
