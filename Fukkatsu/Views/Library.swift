//
//  Library.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 09/08/2023.
//

import SwiftUI

struct Library: View {
    
    enum Option: String, CaseIterable, Identifiable{
        case Favourites, Recents, Downloads
        
        var id: Self { self }
    }
    
    @State private var selectedOption: Option = .Favourites
    
    var body: some View {
        
        Picker("Option", selection: $selectedOption) {
                Text("Favourites").tag(Option.Favourites)
                Text("Recents").tag(Option.Recents)
                Text("Downloads").tag(Option.Downloads)
        }.padding(.horizontal).pickerStyle(.segmented)
        
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
