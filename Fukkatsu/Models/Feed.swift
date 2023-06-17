//
//  Feed.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 23/05/2023.
//

import Foundation

struct FeedRoot: Decodable {
    let data: [Feed]
}

struct Feed: Decodable, Identifiable{
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
