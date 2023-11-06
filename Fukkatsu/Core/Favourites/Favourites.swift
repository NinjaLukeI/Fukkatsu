//
//  Favourites.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 01/11/2023.
//

import SwiftUI

struct Favourites: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        
    ]
    
    @FetchRequest(sortDescriptors: []) var favourites: FetchedResults<Favourite>
    @State var localFavourites: [Favourite] = []
    
    var body: some View {
        
        NavigationView{
            
                    ScrollView{
                        
                        LazyVGrid(columns: columns, spacing: 10){
                            
                            ForEach(favourites){ item in
                                NavigationLink(destination: FeedView(manga: MangaView(id: item.id!))
                                    .navigationBarTitleDisplayMode(.inline)
                                ){
                                    
                                    MangaView(id: item.id!)
                                }
                                .buttonStyle(.plain)
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                    .navigationBarTitle("Favourites")
                    
        }

    }
}

struct Favourites_Previews: PreviewProvider {
    static var previews: some View {
        Favourites()
    }
}
