//
//  MangaChapters.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 23/05/2023.
//

import Foundation

struct MangaFeedRoot: Decodable {
    let data: [MangaFeed]
}

struct MangaFeed: Decodable, Identifiable{
    let id: String
    let type: String // realistically will always be a chapter but whatever
    
    let attributes: feed_Attributes
}

struct feed_Attributes: Decodable{
    let volume: String?
    let chapter: String //Which chapter it is
    let title: String? //Might not have a title
    let publishAt: String
    
}
