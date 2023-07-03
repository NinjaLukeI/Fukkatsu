//
//  Helper.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 30/01/2023.
//

import Foundation


func optionalCheck(value: String?) -> String{
    if let data = value{
        return data
    }
    return ""
}

//check if a string is a double
extension String {
    var isDouble: Bool{
        return Double(self) != nil
    }
    
}

func removeDuplicateElements(manga: [Manga]) -> [Manga] {
    var uniqueManga = [Manga]()
    for item in manga {
        if !uniqueManga.contains(where: {$0.id == item.id }) {
            uniqueManga.append(item)
        }
    }
    return uniqueManga
}

