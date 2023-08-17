//
//  User.swift
//  mangaBackend
//
//  Created by Tobi Oyebanji on 29/07/2023.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let displayName: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: displayName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return "P"
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString,
                                firstName: "Ken",
                                lastName: "Livingston",
                                email: "test@gmail.com",
                                displayName: "Kenny123")
}
