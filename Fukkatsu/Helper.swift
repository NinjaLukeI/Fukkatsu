//
//  Helper.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 30/01/2023.
//

import Foundation

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else{
            return nil
        }
        
        return self[index]
    }
    
    
}

func optionalCheck(value: String?) -> String{
    if let data = value{
        return data
    }
    return ""
}
