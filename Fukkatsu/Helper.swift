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

//extension for URLComponents to accept dictionaries
//extension URLComponents {
//    
//    mutating func setQueryItems(with parameters: [String: String]){
//        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value)}
//    }
//    
//}

