//
//  FavouritesViewModel.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 07/11/2023.
//

import Foundation

@MainActor class FavouritesViewModel: ObservableObject{
    
    @Published var tempID: String?
    
    func setID(id: String){
        self.tempID = id
    }
    
    func getID() -> String{
        if let tempID = tempID{
            return tempID
        }
        return ""
    }
    
}
