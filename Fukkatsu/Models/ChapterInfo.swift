//
//  Feed.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 23/05/2023.
//

import Foundation

struct ChapterInfoRoot: Decodable {
    let data: [ChapterInfo]
}

struct ChapterInfo: Decodable, Identifiable{
    let id: String
    let type: String // realistically will always be a chapter but whatever
    
    let attributes: chInfo_Attributes
}

struct chInfo_Attributes: Decodable{
    let volume: String?
    let chapter: String? //Which chapter it is
    let title: String? //Might not have a title
    let publishAt: String
    
}
